# CLAUDE.md — Guia de Instalação do Agente de IA para WhatsApp

> Este arquivo é lido automaticamente pelo **Claude Code** toda vez que ele abre este projeto. Ele contém o passo-a-passo pra instalar o agente do zero. Se você está começando agora, abra o Claude Code dentro dessa pasta e peça: **"me ajude a instalar esse agente"**. O Claude vai seguir este guia.

---

## 🎯 O que esse template faz

É um agente de IA conversacional para WhatsApp:

- **Recebe** mensagens via Evolution API (texto, áudio, imagem, vídeo, documento, sticker)
- **Transcreve áudios** com OpenAI Whisper
- **Descreve imagens** com OpenAI Vision (gpt-4o-mini)
- **Analisa vídeos** com Gemini (opcional)
- **Gera respostas** com OpenAI `gpt-4.1-mini`
- **Guarda histórico** no Supabase
- **Pode ser pausado** manualmente pra um humano assumir o chat

Ele **não** faz: disparo ativo de mensagens, integrações com gateways de pagamento, campanhas pra listas, follow-ups automáticos. É um template enxuto — base pronta pra você construir em cima.

---

## ✅ Pré-requisitos (o que você precisa ter)

Antes de começar, tenha em mãos:

1. **Um número de WhatsApp dedicado** pro agente (pode ser um chip novo ou um número secundário). NÃO use seu WhatsApp pessoal — o Evolution vai se conectar como um cliente, e usar seu número principal pode causar banimento.
2. **Conta na OpenAI com créditos** — https://platform.openai.com. Gere uma API key em Settings → API Keys.
3. **Conta no Supabase** (grátis) — https://supabase.com
4. **Conta no GitHub** — https://github.com
5. **Conta no Railway** — https://railway.app (tem free tier pra começar)
6. **Conta no Gemini (OPCIONAL)** — só se você quiser que o agente entenda **vídeos**. Gere a chave em https://aistudio.google.com/apikey. Áudio e imagem usam OpenAI, não Gemini.

---

## 🛠️ Stack a instalar na sua máquina

O Claude Code vai rodar esses comandos no terminal pra você. Basta autorizar quando ele perguntar.

### Mac

```bash
# Node.js (via Homebrew)
brew install node

# Git (já vem no Mac normalmente, mas por garantia)
brew install git

# Claude Code (CLI da Anthropic)
npm install -g @anthropic-ai/claude-code
```

### Windows

```powershell
# Node.js (via winget)
winget install OpenJS.NodeJS.LTS

# Git
winget install Git.Git

# Claude Code (CLI da Anthropic)
npm install -g @anthropic-ai/claude-code
```

### Verificar instalação

```bash
node --version     # deve mostrar v20 ou superior
git --version
claude --version
```

---

## 🤖 Instruções para o Claude Code — Siga em ordem

> Atenção, Claude: execute cada fase abaixo **em sequência**, pedindo confirmação ao usuário antes de avançar pra fase seguinte. Não pule etapas.

---

### Fase 1 — Preparar o projeto local

1. Verifique se o projeto está num diretório git inicializado. Se não, rode `git init`.
2. Instale as dependências:
   ```bash
   npm install
   ```
3. Verifique que compila limpo:
   ```bash
   npm run typecheck
   ```
4. Copie o `.env.example` pra `.env` (vai preencher depois):
   ```bash
   cp .env.example .env
   ```
5. Copie o `.mcp.json.example` pra `.mcp.json`:
   ```bash
   cp .mcp.json.example .mcp.json
   ```

---

### Fase 2 — Criar projeto no Supabase

Peça ao usuário pra:

1. Ir em https://supabase.com/dashboard → **New Project**
2. Dar um nome (ex: `agente-whatsapp`), escolher região **South America (São Paulo)** e definir uma senha forte pro database.
3. Aguardar o projeto subir (leva ~2 minutos).
4. Em **Settings → Data API**, copiar:
   - `Project URL` → vai em `SUPABASE_URL` no `.env`
   - `Project API keys → service_role (secret)` → vai em `SUPABASE_SERVICE_ROLE_KEY` no `.env`
5. Em **Settings → General**, copiar o `Reference ID` (ex: `abcdefghijklmn`) — vai no `.mcp.json`.

Depois, edite os arquivos:

- **`.env`**: preencha `SUPABASE_URL` e `SUPABASE_SERVICE_ROLE_KEY`.
- **`.mcp.json`**: substitua `YOUR_PROJECT_REF` pelo Reference ID.

---

### Fase 3 — Conectar o MCP do Supabase ao Claude Code

Depois de editar o `.mcp.json`, **reinicie o Claude Code** (feche e abra de novo nessa pasta). O Claude vai detectar o MCP automaticamente e pedir autorização pra usar — **aprove**.

Teste se funcionou pedindo ao Claude: *"liste as tabelas do meu projeto Supabase"*. Se ele conseguir, o MCP está funcionando.

> Se o MCP pedir um Personal Access Token (PAT), gere um em https://supabase.com/dashboard/account/tokens e siga as instruções na tela do Claude.

---

### Fase 4 — Montar o system prompt do agente (ENTREVISTA)

**Claude, faça estas perguntas ao usuário, uma de cada vez, esperando resposta.** No final, use as respostas pra gerar o system prompt.

#### Perguntas essenciais

1. **Qual é o nome do seu agente?** (ex: "Ana", "Lucas da equipe X", "Suporte da Empresa Y")
2. **O que é o negócio / empresa / produto do qual ele fala?** Descreva em 2-3 frases.
3. **Qual é o objetivo principal do agente?** Escolha um:
   - Vender / qualificar leads
   - Atender dúvidas (SAC)
   - Agendar (consultas, visitas, reuniões)
   - Informar / educar
   - Outro (descreva)
4. **Quem é o público-alvo?** (ex: "donos de pequenos e-commerces", "pacientes que já compraram um plano", "alunos da imersão X")
5. **Qual é o tom de voz?** Escolha (pode combinar):
   - Formal e profissional
   - Amigável e próximo
   - Direto e objetivo
   - Bem-humorado e leve
   - Técnico e detalhista
6. **Que nível de formalidade no português?** ("você", "tu", uso de gírias? emojis? "oi/olá"?)
7. **O que o agente NÃO pode fazer ou dizer?** (ex: "nunca prometer desconto", "nunca falar mal de concorrente", "não dar diagnóstico médico")
8. **Tem uma ação esperada no final da conversa?** (ex: "mandar o link do checkout", "agendar no Cal.com", "pedir o e-mail pra enviar a proposta", "transferir pra um humano")
9. **Tem informações importantes que o agente precisa saber SEMPRE?** (ex: preços, horários, endereço, políticas de reembolso, FAQ). Liste tudo que for relevante.
10. **Tem alguma palavra-chave que, se o usuário digitar, o agente deve parar de responder e chamar um humano?** (ex: "falar com atendente", "cancelar", "reclamação")

#### Perguntas opcionais

11. **Quer limitar o tamanho das respostas?** (default: no máximo 5 mensagens curtas por vez, estilo WhatsApp)
12. **O agente deve sempre se identificar na primeira mensagem?**

#### Com as respostas, monte o system prompt

Claude, gere um system prompt estruturado em seções claras. Use markdown dentro do prompt. Exemplo de estrutura:

```markdown
# Identidade
Você é {{nome}}, {{papel}} da {{empresa}}.

# Contexto do negócio
{{descrição do negócio}}

# Objetivo da conversa
{{objetivo principal}}

# Tom de voz
{{tom + formalidade}}

# Regras (o que NÃO fazer)
- {{restrição 1}}
- {{restrição 2}}
...

# O que o usuário pode pedir — e como responder
{{FAQ / info importante}}

# Ação esperada
{{CTA no fim da conversa}}

# Formato das respostas
- Mande mensagens curtas, estilo WhatsApp (2-4 linhas cada)
- Pode dividir em até 5 mensagens consecutivas se fizer sentido
- Não use markdown (negrito, itálico) — só texto puro
- Não use emojis em excesso (no máximo 1 por mensagem, e só se combinar com o tom)
```

Mostre o prompt final pro usuário e pergunte se ele quer ajustar algo.

---

### Fase 5 — Criar tabelas no Supabase via MCP

Com o prompt aprovado, rode estas ações usando o MCP Supabase:

1. **Aplicar o schema** — leia `supabase/schema.sql` e execute via `mcp__supabase__apply_migration` (com um nome de migração tipo `template_initial_schema`).

2. **Aplicar o seed** — leia `supabase/seed.sql`, substitua os placeholders:
   - `{{SYSTEM_PROMPT}}` → o prompt gerado na Fase 4
   - `{{OPENAI_MODEL}}` → `gpt-4.1-mini` (ou o modelo que o usuário escolheu)
   - Se o usuário der a chave Gemini opcional, adicione um UPDATE pra preencher `gemini_api_key`.

   Execute o SQL resultante via `mcp__supabase__execute_sql`.

3. **Confirmar** — rode `select agent_type, enabled, openai_model, left(system_prompt, 100) as preview from agent_configs;` pra confirmar que ficou no ar.

---

### Fase 6 — Criar repositório no GitHub

1. Peça ao usuário pra criar um repo **privado** em https://github.com/new (nome sugerido: `agente-whatsapp`).
2. Rode os comandos:
   ```bash
   git add .
   git commit -m "chore: projeto inicial a partir do template"
   git branch -M main
   git remote add origin https://github.com/{{usuario}}/{{repo}}.git
   git push -u origin main
   ```

---

### Fase 7 — Subir o Postgres + Evolution API na Railway

Arquitetura final na Railway (3 serviços no mesmo projeto):

```
┌─────────────────┐     ┌──────────────────┐     ┌───────────────────┐
│ evolution-      │────▶│ evolution-api    │◀────│ ia-whatsapp-app   │
│ postgres        │     │ (a Evolution)    │     │ (este projeto)    │
│ (PostgreSQL)    │     │                  │     │                   │
└─────────────────┘     └──────────────────┘     └───────────────────┘
```

#### 7.1 — Criar projeto na Railway

1. Entre em https://railway.app/new
2. Crie um **New Project** → "Empty Project". Dê um nome (ex: `whatsapp-agent`).

#### 7.2 — Adicionar o Postgres do Evolution

1. Dentro do projeto, **+ New** → **Database** → **Add PostgreSQL**.
2. Renomeie o serviço pra `evolution-postgres` (aba Settings → nome).
3. Aguarde subir. Depois abra o serviço e vá em **Variables** — guarde a `DATABASE_URL` interna (algo como `postgresql://postgres:SENHA@postgres.railway.internal:5432/railway`).

#### 7.3 — Adicionar o Evolution API

1. **+ New** → **Docker Image** → digite `atendai/evolution-api:latest` (ou a versão mais recente estável).
2. Renomeie o serviço pra `evolution-api`.
3. Em **Variables**, adicione (ajuste o `AUTHENTICATION_API_KEY` gerando um valor aleatório forte — pode usar `openssl rand -hex 32`):

   ```
   SERVER_TYPE=http
   SERVER_PORT=8080
   SERVER_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
   AUTHENTICATION_API_KEY=<gere-uma-chave-forte-aqui>
   DATABASE_ENABLED=true
   DATABASE_PROVIDER=postgresql
   DATABASE_CONNECTION_URI=${{evolution-postgres.DATABASE_URL}}
   DATABASE_CONNECTION_CLIENT_NAME=evolution_exchange
   CACHE_REDIS_ENABLED=false
   CACHE_LOCAL_ENABLED=true
   LOG_LEVEL=ERROR,WARN,INFO
   CONFIG_SESSION_PHONE_CLIENT=Chrome
   CONFIG_SESSION_PHONE_NAME=Chrome
   ```

   > `${{evolution-postgres.DATABASE_URL}}` é uma referência do Railway — ele substitui pelo valor real automaticamente.

4. Em **Settings → Networking**, clique **Generate Domain** pra pegar uma URL pública (ex: `evolution-api-production-xxxx.up.railway.app`).

5. Em **Settings → Source**, garanta que a imagem Docker está setada corretamente e aguarde o build/deploy.

6. Abra `https://<seu-evolution>.up.railway.app/manager` no navegador, faça login com a `AUTHENTICATION_API_KEY` que você gerou, e **crie uma instância** nova chamada (por exemplo) `agente`. Guarde esse nome — vai em `EVOLUTION_INSTANCE` no app.

7. Ainda no Manager, clique na instância → **QR Code** → escaneie com o WhatsApp do número dedicado (Configurações → Aparelhos conectados → Conectar aparelho).

#### 7.4 — Adicionar o app (este projeto)

1. No mesmo projeto Railway, **+ New** → **GitHub Repo** → escolha o repo que você criou na Fase 6.
2. Renomeie o serviço pra `ia-whatsapp-app`.
3. Em **Variables**, adicione:

   ```
   NODE_ENV=production
   PORT=3000
   LOG_LEVEL=info
   SUPABASE_URL=<do .env>
   SUPABASE_SERVICE_ROLE_KEY=<do .env>
   EVOLUTION_URL=http://evolution-api.railway.internal:8080
   EVOLUTION_API_KEY=<a AUTHENTICATION_API_KEY do Evolution>
   EVOLUTION_INSTANCE=agente
   OPENAI_API_KEY=<sua chave OpenAI>
   ```

   > Na rede interna do Railway usamos `http://evolution-api.railway.internal:8080` — não precisa de HTTPS e é grátis (não conta tráfego).

4. Em **Settings → Networking**, clique **Generate Domain** pra ter uma URL pública (ex: `ia-whatsapp-app-production-xxxx.up.railway.app`).

5. Aguarde o deploy. Teste o healthcheck: `https://<seu-app>.up.railway.app/health` — deve retornar `{"status":"ok"}`.

---

### Fase 8 — Configurar o webhook do Evolution pro app

No Evolution Manager:

1. Abra a sua instância (a que você conectou o WhatsApp na Fase 7.3).
2. Vá em **Webhook** (ou **Events** / **Configurações**).
3. Configure:
   - **URL**: `https://<seu-app>.up.railway.app/webhooks/evolution`
   - **Events**: marque `messages.upsert` e `messages.update`
   - **Enabled**: true
4. Salve.

Alternativamente, via API (PowerShell/curl):

```bash
curl -X POST "https://<seu-evolution>.up.railway.app/webhook/set/<nome-instancia>" \
  -H "apikey: <AUTHENTICATION_API_KEY>" \
  -H "Content-Type: application/json" \
  -d '{
    "webhook": {
      "enabled": true,
      "url": "https://<seu-app>.up.railway.app/webhooks/evolution",
      "events": ["MESSAGES_UPSERT", "MESSAGES_UPDATE"]
    }
  }'
```

---

### Fase 9 — Testar

1. Mande uma mensagem pro número do agente a partir de outro WhatsApp.
2. Veja o log do `ia-whatsapp-app` na Railway — deve aparecer o webhook sendo recebido e o agente respondendo em ~15s (tempo do debounce).
3. Confira no Supabase (tabela `chat_messages`) que as mensagens estão sendo salvas.

Se não responder, veja a seção **Troubleshooting** abaixo.

---

## 🧰 Troubleshooting

### O app não responde
- Verifique os logs do `ia-whatsapp-app` na Railway.
- Cheque se `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `EVOLUTION_URL`, `EVOLUTION_API_KEY` e `OPENAI_API_KEY` estão preenchidos.
- Rode no terminal local: `curl https://<seu-app>.up.railway.app/health` — deve retornar ok.

### O Evolution não envia webhook
- No Manager, veja se o webhook está **enabled** e os events `messages.upsert` / `messages.update` estão marcados.
- A URL deve ser a **pública** do app (não a `.railway.internal`).
- Cheque os logs do `evolution-api` — erros de "webhook post failed" aparecem lá.

### OpenAI dá erro 401
- Chave errada ou sem créditos. Renove em https://platform.openai.com/api-keys e faça um top-up de créditos.

### A IA responde mas o usuário não recebe no WhatsApp
- Confira que a `EVOLUTION_INSTANCE` no `.env` do app bate **exatamente** com o nome criado no Manager.
- Veja se a instância ainda está conectada (o QR Code expira — reconecte se necessário).

### Quero pausar a IA pra falar com o usuário manualmente
Rode no SQL Editor do Supabase:
```sql
update chat_control
set ai_paused = true, paused_at = now(), paused_by = 'humano'
where session_id = '<numero>@s.whatsapp.net';
```
Pra despausar, volte `ai_paused = false`.

---

## 📂 Estrutura do projeto

```
src/
├── config/env.ts                    # validação das env vars com Zod
├── lib/
│   ├── evolution.ts                 # cliente HTTP da Evolution
│   ├── logger.ts                    # Pino com redação de secrets
│   ├── openai.ts                    # factory de clientes OpenAI
│   ├── phone.ts                     # normalização de telefone BR
│   └── supabase.ts                  # cliente Supabase service-role
├── routes/
│   ├── health.ts                    # /health e /health/ready
│   └── webhooks/evolution.ts        # POST /webhooks/evolution
├── services/
│   ├── agent.ts                     # chamada ao OpenAI com system prompt
│   ├── agent-config.ts              # cache de agent_configs
│   ├── buffer.ts                    # buffer + debounce + sweeper
│   ├── chatbot.ts                   # orquestração principal
│   ├── media.ts                     # áudio/imagem/vídeo/doc processing
│   └── message-parsers.ts           # parsers de tipos de mensagem WhatsApp
└── server.ts                        # Fastify + bootstrap

supabase/
├── schema.sql                       # DDL de todas as tabelas + RPC
└── seed.sql                         # INSERT inicial em agent_configs
```

---

## 🔐 Segurança — nunca commite

- `.env` (já gitignored)
- `.mcp.json` (já gitignored)
- Tudo dentro de `.claude/`

Se você commitou secret por acidente, **gire a chave imediatamente** (OpenAI, Supabase, Evolution) e faça rewrite do histórico ou parta pra um repo novo.
