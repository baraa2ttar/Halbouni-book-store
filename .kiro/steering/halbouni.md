Halbouni Book Store user app (Flutter). Read PROJECT_CONTEXT.md before any work.
- Never run SQL/DDL/RLS/RPC changes on Supabase (including through any Supabase MCP). Write a schema request and stop.
- No secrets in git. Roles only from app_metadata. Never user_metadata.
- Keep the architecture: feature-first, data/domain/presentation, Cubit + sealed states, get_it, go_router, Either<Failure,T>. No new state-management or DI library. Dev/test packages (bloc_test, mocktail) and intl are allowed.
- Currency is the NEW Syrian pound (SYP), whole numbers, never "$". English now, Arabic/RTL later: use EdgeInsetsDirectional/start-end alignment, keep user-facing strings in one place, no hardcoded left/right.
- Small, verified changes. After every task run flutter analyze and flutter test and report the results.
- Report format: files changed (one line each), what you verified and how, schema requests, anything that contradicted PROJECT_CONTEXT.md.