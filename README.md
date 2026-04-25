# Template — Agente de IA para WhatsApp

Template enxuto de agente conversacional pra WhatsApp. Recebe mensagens via **Evolution API**, processa texto/áudio/imagem/vídeo com **OpenAI + Gemini**, persiste no **Supabase** e responde no WhatsApp. Feito pra rodar na **Railway**.

## Como instalar (em 4 passos)

A instalação inteira é feita conversando em português com o **app Claude Code** — sem terminal, sem código.

### 1) Baixe o Claude Code (app desktop)

👉 https://claude.com/download

Disponível pra Mac e Windows. Faça login com sua conta Anthropic (precisa de plano pago — Pro ou superior).

### 2) Baixe o template (zip)

👉 https://github.com/orodrigobarcelos/imersao-sac-agente-ia-whatsapp/archive/refs/heads/main.zip

Extraia o zip num lugar fácil de achar (ex: a pasta `Documentos`).

### 3) Abra a pasta no Claude Code

No app do Claude Code: **File → Open Folder** (ou **Abrir Pasta**) → escolha a pasta que você acabou de extrair.

### 4) Diga ao Claude:

> *"me ajude a instalar esse agente do zero"*

O Claude vai ler o arquivo [`CLAUDE.md`](./CLAUDE.md) e te guiar passo-a-passo:

1. Instala o que falta na sua máquina (Node, Git etc) — sozinho
2. Te ajuda a criar conta no Supabase, Railway e gerar as chaves da OpenAI
3. **Te entrevista** com 10 perguntas pra montar a personalidade do SEU agente (nome, negócio, tom de voz, regras…)
4. Cria as tabelas no Supabase via MCP
5. Sobe o Evolution API + Postgres + o agente na Railway
6. Configura o webhook
7. Conecta o WhatsApp pelo QR Code
8. Testa

**Tempo estimado:** ~1 hora pra alguém leigo. ~20 minutos pra quem já mexeu com isso.

## Stack

- **Node 20+ / TypeScript** (Fastify)
- **Supabase** — histórico, config do agente, controle de pause
- **Evolution API** — ponte WhatsApp
- **OpenAI** — `gpt-4.1-mini` (texto) + `whisper-1` (áudio) + `gpt-4o-mini` (imagens)
- **Gemini** (opcional) — análise de vídeos

## Você vai precisar de (todas grátis pra começar):

- 📱 Um número de WhatsApp dedicado pro agente (NÃO use seu pessoal)
- 🤖 Conta Anthropic com plano Claude Pro (pra usar o Claude Code)
- 🧠 Conta OpenAI com créditos (mínimo $5)
- 🗄️ Conta Supabase (free tier serve)
- 🚂 Conta Railway (free tier serve no início; ~$5/mês depois)
- 🐙 Conta GitHub
- 🎬 Conta Gemini (OPCIONAL — só pra analisar vídeos)

## O que esse template NÃO faz

- Disparo ativo de mensagens pra listas
- Integração com gateway de pagamento / CRM
- Follow-ups agendados
- Fluxos de venda específicos

É uma base limpa. Adicione o que precisar em cima.

## Licença

MIT.
