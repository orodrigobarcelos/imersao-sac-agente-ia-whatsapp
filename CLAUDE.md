# CLAUDE.md — Guia de Instalação do Agente de IA para WhatsApp

> Este arquivo é lido automaticamente pelo **Claude Code** toda vez que ele abre este projeto. Ele contém o passo-a-passo pra instalar o agente do zero, **sem precisar saber programar**.
>
> Se você é o usuário leigo: abra o app do Claude Code, aponte pra essa pasta, e mande: **"me ajude a instalar esse agente do zero"** — o Claude vai seguir este guia.
>
> Se você é o Claude Code: siga as fases abaixo em ordem, pedindo confirmação ao usuário entre cada uma. **Fale em português, em tom amigável e explicativo. Assuma que o usuário não sabe NADA de programação.**

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

## ✅ Pré-requisitos (contas que você precisa criar antes)

Tenha em mãos antes de começar:

1. 📱 **Um número de WhatsApp dedicado** pro agente (chip novo ou número secundário). NÃO use seu WhatsApp pessoal — risco de banimento.
2. 🤖 **Conta Anthropic** com **plano Claude Pro** (ou superior) — pra usar o app Claude Code. https://claude.com/upgrade
3. 🧠 **Conta na OpenAI com créditos** (mínimo $5) — https://platform.openai.com → Settings → Billing → Add credits.
4. 🗄️ **Conta no Supabase** (free tier serve) — https://supabase.com
5. 🐙 **Conta no GitHub** — https://github.com
6. 🚂 **Conta no Railway** — https://railway.app (free tier serve no início; depois ~$5/mês)
7. 🎬 **Conta no Gemini (OPCIONAL)** — só se quiser que o agente entenda **vídeos**. Áudio e imagem usam OpenAI. Chave em https://aistudio.google.com/apikey

**Custo estimado**: ~$10/mês pra começar (OpenAI sob demanda + Railway). Se usar pouco, fica abaixo de $20/mês.

---

## 🤖 Fases da instalação

> Claude, execute em ordem. Confirme com o usuário ao terminar cada fase antes de avançar pra próxima.

---

### Fase 0 — Preparar a máquina (instala o que falta)

O usuário pode estar com nada instalado. Você (Claude) vai detectar e instalar.

**Detectar o que tem:**

```bash
node --version
git --version
```

Se algum não estiver instalado, instale automaticamente:

#### No Mac

Se Homebrew não estiver instalado:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Depois:
```bash
brew install node git gh
```

#### No Windows

```powershell
winget install OpenJS.NodeJS.LTS
winget install Git.Git
winget install GitHub.cli
```

**Validar:**
```bash
node --version    # deve mostrar v20+
git --version
gh --version
```

Diga ao usuário em linguagem simples o que foi instalado.

---

### Fase 1 — Login no GitHub e na Railway (CLI)

```bash
gh auth login
```

Escolha **GitHub.com → HTTPS → Yes (autenticar git) → Login with a web browser**. Vai abrir o navegador, faça login.

Depois (opcional, ajuda no deploy automatizado):
```bash
npm install -g @railway/cli
railway login
```

---

### Fase 2 — Preparar o projeto local

1. Instalar dependências do projeto:
   ```bash
   npm install
   ```
2. Validar que compila:
   ```bash
   npm run typecheck
   ```
3. Criar arquivos de configuração local (vão ser preenchidos nas próximas fases):
   ```bash
   cp .env.example .env
   cp .mcp.json.example .mcp.json
   ```

---

### Fase 3 — Criar projeto no Supabase

Diga ao usuário pra:

1. Ir em https://supabase.com/dashboard → **New Project**
2. Nome: `agente-whatsapp` (ou outro), região **South America (São Paulo)**, senha forte pro database (anote!).
3. Aguardar ~2 minutos pra subir.
4. Em **Settings → Data API**, copiar:
   - `Project URL` → `SUPABASE_URL`
   - `Project API keys → service_role (secret)` → `SUPABASE_SERVICE_ROLE_KEY`
5. Em **Settings → General**, copiar o `Reference ID`.

Você (Claude) edita os arquivos automaticamente quando o usuário colar os valores no chat:
- `.env`: preencha `SUPABASE_URL` e `SUPABASE_SERVICE_ROLE_KEY`.
- `.mcp.json`: substitua `YOUR_PROJECT_REF` pelo Reference ID.

---

### Fase 4 — Conectar o MCP do Supabase ao Claude Code

Depois de editar o `.mcp.json`, **peça ao usuário pra fechar e abrir o Claude Code de novo nessa pasta** (o MCP só carrega na inicialização).

Quando ele reabrir, o Claude Code vai detectar o MCP e pedir autorização — ele aprova.

Teste com: *"liste as tabelas do meu Supabase"*. Se funcionar, MCP tá ativo.

> Se pedir um Personal Access Token (PAT), o usuário gera em https://supabase.com/dashboard/account/tokens

---

### Fase 5 — Entrevista pra montar o system prompt do agente

**ESSA É A FASE MAIS IMPORTANTE.** É onde a personalidade do agente nasce.

Faça as 10 perguntas abaixo **uma de cada vez**, esperando o usuário responder antes de avançar. Use tom de conversa, não de formulário. Você pode reformular a pergunta se sentir que o usuário não entendeu.

#### Perguntas

1. **Qual é o nome do seu agente?** (ex: "Ana", "Lucas da equipe X", "Suporte da Empresa Y")
2. **O que é o negócio / empresa / produto do qual ele fala?** Em 2-3 frases.
3. **Qual é o objetivo principal do agente?**
   - Vender / qualificar leads
   - Atender dúvidas (SAC)
   - Agendar (consultas, visitas, reuniões)
   - Informar / educar
   - Outro (descreva)
4. **Quem é o público-alvo?** (ex: "donos de pequenos e-commerces", "pacientes que já compraram um plano", "alunos da imersão X")
5. **Qual é o tom de voz?** Pode combinar:
   - Formal e profissional
   - Amigável e próximo
   - Direto e objetivo
   - Bem-humorado e leve
   - Técnico e detalhista
6. **Que nível de formalidade no português?** ("você", "tu", gírias? emojis? "oi/olá"?)
7. **O que o agente NÃO pode fazer ou dizer?** (ex: nunca prometer desconto, nunca falar mal de concorrente, não dar diagnóstico médico)
8. **Tem uma ação esperada no final da conversa?** (ex: mandar link do checkout, agendar no Cal.com, pedir e-mail pra enviar proposta, transferir pra humano)
9. **Que informações importantes o agente precisa saber SEMPRE?** (preços, horários, endereço, política de reembolso, FAQ — liste tudo)
10. **Tem palavra-chave que, se o usuário digitar, deve pausar o agente e chamar um humano?** (ex: "atendente", "cancelar", "reclamação")

Pergunte se ele quer ajustar algo antes de salvar. **Mostre o prompt final em markdown e peça aprovação explícita.**

#### Estrutura do prompt final

Monte assim:

```markdown
# Identidade
Você é {{nome}}, {{papel}} da {{empresa}}.

# Contexto do negócio
{{descrição}}

# Objetivo da conversa
{{objetivo}}

# Tom de voz
{{tom + formalidade}}

# Regras (o que NÃO fazer)
- {{restrição 1}}
- {{restrição 2}}

# Informações importantes
{{FAQ / dados que ele precisa saber}}

# Ação esperada
{{CTA no fim da conversa}}

# Comportamento de pausa
Se o usuário digitar palavras como {{palavras-chave}}, responda apenas: "Vou chamar um atendente humano pra te ajudar, só um momento" e pare.

# Formato das respostas
- Mensagens curtas, estilo WhatsApp (2-4 linhas cada)
- Pode dividir em até 5 mensagens consecutivas se fizer sentido
- Não use markdown (negrito, itálico) — só texto puro
- Use no máximo 1 emoji por mensagem, e só se combinar com o tom
- Sempre responda em português brasileiro
```

---

### Fase 6 — Criar tabelas no Supabase via MCP

Com o prompt aprovado:

1. **Aplicar o schema** — leia `supabase/schema.sql` e execute via `mcp__supabase__apply_migration` (nome: `template_initial_schema`).

2. **Aplicar o seed** — leia `supabase/seed.sql`, substitua os placeholders:
   - `{{SYSTEM_PROMPT}}` → o prompt da Fase 5
   - `{{OPENAI_MODEL}}` → `gpt-4.1-mini`
   - Se o usuário deu chave Gemini, adicione `update agent_configs set gemini_api_key = '...' where agent_type = 'default';`

   Execute via `mcp__supabase__execute_sql`.

3. **Confirmar**: `select agent_type, enabled, openai_model, length(system_prompt) as prompt_chars from agent_configs;`

---

### Fase 7 — Criar repositório no GitHub

Como o repositório do template é PÚBLICO, o usuário precisa criar uma cópia PRIVADA pra ele.

```bash
gh repo create agente-whatsapp --private --source=. --remote=origin --push
```

Substitua `agente-whatsapp` pelo nome que ele preferir.

---

### Fase 8 — Subir Postgres + Evolution API + app na Railway

Arquitetura final (3 serviços no mesmo projeto Railway):

```
┌─────────────────┐     ┌──────────────────┐     ┌───────────────────┐
│ evolution-      │────▶│ evolution-api    │◀────│ ia-whatsapp-app   │
│ postgres        │     │ (Evolution)      │     │ (este projeto)    │
└─────────────────┘     └──────────────────┘     └───────────────────┘
```

#### 8.1 — Criar projeto na Railway

1. Vá em https://railway.app/new
2. **New Project** → "Empty Project". Nome: `whatsapp-agent`.

#### 8.2 — Postgres do Evolution

1. Dentro do projeto: **+ New** → **Database** → **PostgreSQL**.
2. Renomeie pra `evolution-postgres` (Settings → nome).

#### 8.3 — Evolution API

1. **+ New** → **Docker Image** → `atendai/evolution-api:latest`.
2. Renomeie pra `evolution-api`.
3. Em **Variables**, cole (gere a `AUTHENTICATION_API_KEY` aleatória — peça ao usuário pra rodar `openssl rand -hex 32` ou use o gerador interno):

   ```
   SERVER_TYPE=http
   SERVER_PORT=8080
   SERVER_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
   AUTHENTICATION_API_KEY=<chave-forte-aleatória>
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

4. **Settings → Networking → Generate Domain** (URL pública).
5. Aguardar deploy.
6. Abrir `https://<seu-evolution>.up.railway.app/manager`, login com a `AUTHENTICATION_API_KEY`, **criar instância** (ex: `agente`).
7. Clicar na instância → **QR Code** → escanear com o WhatsApp dedicado.

#### 8.4 — App (este projeto)

1. **+ New** → **GitHub Repo** → o repo criado na Fase 7.
2. Renomeie pra `ia-whatsapp-app`.
3. Em **Variables**:

   ```
   NODE_ENV=production
   PORT=3000
   LOG_LEVEL=info
   SUPABASE_URL=<do .env>
   SUPABASE_SERVICE_ROLE_KEY=<do .env>
   EVOLUTION_URL=http://evolution-api.railway.internal:8080
   EVOLUTION_API_KEY=<a AUTHENTICATION_API_KEY do Evolution>
   EVOLUTION_INSTANCE=agente
   OPENAI_API_KEY=<chave OpenAI>
   ```

4. **Settings → Networking → Generate Domain**.
5. Aguardar deploy. Testar: `https://<seu-app>.up.railway.app/health` deve retornar `{"status":"ok"}`.

---

### Fase 9 — Configurar webhook do Evolution

No Evolution Manager, instância → **Webhook**:

- **URL**: `https://<seu-app>.up.railway.app/webhooks/evolution`
- **Events**: `MESSAGES_UPSERT` e `MESSAGES_UPDATE`
- **Enabled**: true

Ou via API:

```bash
curl -X POST "https://<evolution>.up.railway.app/webhook/set/<instancia>" \
  -H "apikey: <AUTH_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"webhook":{"enabled":true,"url":"https://<app>.up.railway.app/webhooks/evolution","events":["MESSAGES_UPSERT","MESSAGES_UPDATE"]}}'
```

---

### Fase 10 — Testar 🎉

1. Manda mensagem pro número do agente de outro WhatsApp.
2. Em ~15s o agente responde (debounce default).
3. Veja os logs do `ia-whatsapp-app` na Railway pra confirmar.
4. Veja a tabela `chat_messages` no Supabase — vai ter os registros.

**Pronto! O agente tá no ar.** 🚀

Se algo deu errado, veja **Troubleshooting** abaixo.

---

## 🧰 Troubleshooting

### O app não responde
- Veja os logs do `ia-whatsapp-app` na Railway.
- Cheque se `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `EVOLUTION_URL`, `EVOLUTION_API_KEY` e `OPENAI_API_KEY` estão preenchidos.
- Healthcheck: `https://<app>.up.railway.app/health` deve retornar ok.

### O Evolution não envia webhook
- No Manager, veja se está **enabled** com `MESSAGES_UPSERT` / `MESSAGES_UPDATE` marcados.
- A URL deve ser **pública** do app (não a `.railway.internal`).
- Logs do `evolution-api` mostram erros de "webhook post failed".

### OpenAI dá erro 401
- Chave errada ou sem créditos. Renove em https://platform.openai.com/api-keys e adicione créditos.

### IA responde no log mas WhatsApp não recebe
- `EVOLUTION_INSTANCE` no `.env` do app deve bater **exatamente** com o nome no Manager.
- Instância pode ter desconectado — reabra o QR Code.

### Pausar a IA pra falar com o usuário manualmente
SQL no Supabase:
```sql
update chat_control
set ai_paused = true, paused_at = now(), paused_by = 'humano'
where session_id = '<numero>@s.whatsapp.net';
```
Pra despausar: `ai_paused = false`.

### Mudar o system prompt depois
SQL no Supabase:
```sql
update agent_configs
set system_prompt = '...novo prompt...'
where agent_type = 'default';
```
A app tem cache de 30s — depois disso o novo prompt entra em vigor.

---

## 📂 Estrutura do projeto

```
src/
├── config/env.ts                    # validação das env vars (Zod)
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
│   ├── agent.ts                     # chamada OpenAI com system prompt
│   ├── agent-config.ts              # cache de agent_configs
│   ├── buffer.ts                    # buffer + debounce + sweeper
│   ├── chatbot.ts                   # orquestração principal
│   ├── media.ts                     # áudio/imagem/vídeo/doc processing
│   └── message-parsers.ts           # parsers de tipos WhatsApp
└── server.ts                        # Fastify + bootstrap

supabase/
├── schema.sql                       # tabelas + RPC
└── seed.sql                         # INSERT inicial (modelo)
```

---

## 🔐 Segurança — NUNCA commite

- `.env` (já gitignored)
- `.mcp.json` (já gitignored)
- Tudo dentro de `.claude/`

Se commitar secret por acidente, **gire a chave imediatamente** (OpenAI, Supabase, Evolution).
