-- ============================================================================
--  Seed inicial do agente.
--
--  IMPORTANTE: este arquivo é um MODELO. O Claude Code vai te fazer perguntas
--  (nome do agente, negócio, objetivo, tom de voz, etc) e substituir os
--  placeholders abaixo com o prompt real antes de rodar este SQL.
--
--  Placeholders a substituir:
--    {{SYSTEM_PROMPT}}  → o prompt do sistema montado a partir das suas respostas
--    {{OPENAI_MODEL}}   → default: gpt-4.1-mini
-- ============================================================================

insert into public.agent_configs (
  agent_type,
  enabled,
  openai_model,
  system_prompt,
  debounce_ms,
  typing_ms,
  inter_message_delay_ms,
  history_limit,
  max_output_messages
) values (
  'default',
  true,
  '{{OPENAI_MODEL}}',
  $SYSTEM_PROMPT${{SYSTEM_PROMPT}}$SYSTEM_PROMPT$,
  15000,
  1000,
  1000,
  30,
  5
)
on conflict (agent_type) do update set
  enabled               = excluded.enabled,
  openai_model          = excluded.openai_model,
  system_prompt         = excluded.system_prompt,
  updated_at            = now();
