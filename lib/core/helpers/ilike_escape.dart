/// Escapes the `ilike` metacharacters (`\`, `%`, `_`) so that user input is
/// matched literally inside a PostgREST `ilike` pattern.
///
/// PostgREST maps `ilike` to PostgreSQL `ILIKE`, whose default escape
/// character is the backslash.
///
/// The backslash is escaped FIRST. Escaping `%` or `_` first would add
/// backslashes that the backslash pass then escapes a second time.
String escapeIlikePattern(String query) {
  return query
      .replaceAll('\\', '\\\\')
      .replaceAll('%', '\\%')
      .replaceAll('_', '\\_');
}
