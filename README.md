# Template — Agente de IA para WhatsApp

Template enxuto de agente conversacional pra WhatsApp. Recebe mensagens via **Evolution API**, processa texto/áudio/imagem/vídeo com **OpenAI + Gemini**, persiste no **Supabase** e responde no WhatsApp. Feito pra rodar na **Railway**.

## Stack

- **Node 20+ / TypeScript** (Fastify)
- **Supabase** — histórico, config do agente, controle de pause
- **Evolution API** — ponte WhatsApp
- **OpenAI** — `gpt-4.1-mini` (texto) + `whisper-1` (áudio) + `gpt-4o-mini` (imagens)
- **Gemini** (opcional) — análise de vídeos

## Instalação

A instalação é **guiada pelo Claude Code**. Abra o Claude Code dentro dessa pasta e diga:

> *"me ajude a instalar esse agente"*

O Claude vai seguir o passo-a-passo do arquivo [`CLAUDE.md`](./CLAUDE.md) — desde criar o projeto no Supabase, subir o Evolution na Railway, configurar o webhook, até te entrevistar pra montar o system prompt do seu agente.

Não tem Claude Code? Instale:

```bash
npm install -g @anthropic-ai/claude-code
claude
```

## O que esse template NÃO faz

- Disparo ativo de mensagens pra listas
- Integração com gateway de pagamento / CRM
- Follow-ups agendados
- Fluxos de venda específicos

É uma base limpa. Adicione o que precisar em cima.

## Licença

MIT.
