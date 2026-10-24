# Requirements Document

## Introduction

This feature establishes a clean, reproducible baseline of the Halbouni Book Store user app. The goal is not to add features or change the backend schema, but to make the repository build reliably on any machine, carry accurate documentation, return catalog lists in a stable order, handle search safely, run CI, and contain no analyzer warnings or committed secrets. The scope is limited to the user app in this repository; the admin app, the application id, the `lib/Features` names, and the live Supabase schema are explicitly out of scope.

## Glossary

- **App**: the Halbouni Book Store user Flutter application (package `adv`) in this repository.
- **Build_Configuration**: the Android build settings, specifically `android/gradle.properties`.
- **Catalog_Query**: any Supabase query in `HomeRepoImpl` that returns a list of products (featured, newest, by-category, and search).
- **CI**: the GitHub Actions continuous integration workflow for this repository.
- **Developer**: a person who sets up and builds the App on a machine.
- **Documentation_File**: a Markdown or SQL file under the `docs/` directory.
- **Machine_Specific_Path**: a filesystem path tied to a single machine, such as `org.gradle.java.home`.
- **PROJECT_CONTEXT.md**: the project's source-of-truth document at the repository root.
- **README**: the file `README.md` at the repository root.
- **Search_Cubit**: the search feature state holder that provides a stale-response guard.
- **Search_View**: the search feature view that provides an input debounce.
- **Secret**: any non-public credential, including service-role keys, API keys, keystores, and `.env` file contents.
- **Secrets_Audit**: the process of scanning the repository for committed secrets and reporting findings without modifying any files, values, or git history.
- **Stale_Response_Guard**: the request-id mechanism in `SearchCubit` that discards results from superseded queries.

## Requirements

### Requirement 1: Portable Build Configuration

**User Story:** As a Developer, I want the Android build configuration to be machine-independent, so that the App builds on any machine using the environment's Java.

#### Acceptance Criteria

1. THE Build_Configuration SHALL NOT contain the `org.gradle.java.home` property.
2. THE Build_Configuration SHALL keep `android.newDsl=false` and `android.builtInKotlin=false`.
3. THE Build_Configuration SHALL NOT contain any comment that includes the text '8.7.3'.
4. IF `JAVA_HOME` is set in the environment, THEN THE App SHALL complete a debug build that produces an APK file using the Java installation specified by `JAVA_HOME`.

### Requirement 2: Accurate README

**User Story:** As a Developer, I want a README that explains the App and how to run it, so that the project can be set up and built correctly.

#### Acceptance Criteria

1. THE README SHALL be valid UTF-8 text that decodes without encoding errors and contains no non-printing characters other than standard whitespace.
2. THE README SHALL state the app name and describe the app as a mobile store selling physical books and board games in Damascus with cash-on-delivery delivery.
3. THE README SHALL document running the App with `flutter pub get` followed by `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`.
4. THE README SHALL contain an architecture paragraph of at least 3 sentences describing the app's feature-first organization and the data, domain, and presentation layers used within each feature.
5. THE README SHALL link to `PROJECT_CONTEXT.md`.
6. THE README SHALL document Flutter 3.47.3 as the required Flutter SDK version and any build prerequisites needed before running the App.

### Requirement 3: Documentation Hygiene

**User Story:** As a Developer, I want only current, trustworthy documentation in the repository, so that the Developer is not misled by stale or unsafe files.

#### Acceptance Criteria

1. THE repository SHALL delete `docs/BACKEND_SETUP.sql` without archiving or moving it elsewhere.
2. IF a Documentation_File contains statements that are inconsistent with statements in PROJECT_CONTEXT.md, THEN THE Documentation_File SHALL begin with the first-line banner "HISTORICAL, not a source of truth. See PROJECT_CONTEXT.md".
3. THE repository SHALL ensure that `docs/ADMIN_DASHBOARD_PROMPT.md`, `docs/PROJECT_DESCRIPTION.md`, and `docs/DESIGN_GUIDE.md` each begin with the first-line banner "HISTORICAL, not a source of truth. See PROJECT_CONTEXT.md".

### Requirement 4: Deterministic Catalog Ordering

**User Story:** As a customer, I want product lists to come back in a stable order across refreshes, so that the catalog does not jump between fetches.

#### Acceptance Criteria

1. WHEN fetching products for a category, THE Catalog_Query SHALL order results by `created_at` descending, then by `id` as a tie-breaker.
2. WHEN fetching featured products, THE Catalog_Query SHALL order results by `created_at` descending, then by `id` as a tie-breaker.
3. WHEN fetching newest products, THE Catalog_Query SHALL order results by `created_at` descending, then by `id` as a tie-breaker.
4. WHILE the underlying product data is unchanged, THE Catalog_Query SHALL return results in the same order across repeated fetches.

### Requirement 5: Safe Product Search

**User Story:** As a customer, I want search to handle special characters and return a bounded result set, so that searches containing `%` or `_` work correctly and never return an unbounded list.

#### Acceptance Criteria

1. WHEN the search text contains `%`, `_`, or `\`, THE Catalog_Query SHALL match those characters as literals rather than wildcard metacharacters in the ilike pattern.
2. THE Catalog_Query SHALL return at most 50 products for any search request.
3. THE Search_View SHALL preserve the existing input debounce without modification.
4. THE Search_Cubit SHALL preserve the existing Stale_Response_Guard without modification.

### Requirement 6: Continuous Integration

**User Story:** As a maintainer, I want CI to run on every push and pull request, so that regressions are caught before merge.

#### Acceptance Criteria

1. WHEN a push occurs or a pull request is opened or updated, THE CI SHALL run `flutter pub get`.
2. THE CI SHALL run `flutter analyze`.
3. THE CI SHALL run `flutter test`.
4. THE CI SHALL use Flutter 3.47.3 (stable channel) as the exact pinned version, not 'latest' or 'latest stable'.

### Requirement 7: Secrets Audit

**User Story:** As a maintainer, I want to know whether any secrets are committed to the repository, so that secrets can be removed without rewriting git history.

#### Acceptance Criteria

1. WHEN the Secrets_Audit is invoked, THE Secrets_Audit SHALL scan all files committed to the repository for API keys, service-role keys, keystores, and `.env` files.
2. THE Secrets_Audit SHALL NOT report the Supabase URL and publishable anon key in `lib/core/constant/supabase_config.dart` as secrets, as they are public by design; they MAY be listed as 'public by design'.
3. THE Secrets_Audit SHALL report each finding's file path and category only, and SHALL NOT include the secret values themselves in the report.
4. THE Secrets_Audit SHALL NOT rewrite git history.
5. THE Secrets_Audit SHALL NOT edit, redact, or modify any Secret values found.
6. IF the scan finds no Secrets, THEN THE Secrets_Audit SHALL report that no secrets were found.

### Requirement 8: Clean Baseline Verification

**User Story:** As a maintainer, I want the baseline to pass static analysis, tests, and build, so that the repository is in a clean, reproducible state.

#### Acceptance Criteria

1. THE App SHALL pass `flutter analyze` with zero issues reported, including no errors, warnings, or info messages.
2. THE App SHALL pass `flutter test`.
3. THE App SHALL build a debug APK.
4. WHEN applying fixes to resolve issues reported by `flutter analyze`, THE fixes SHALL be limited to the code flagged by the analyzer as causing those issues and SHALL NOT involve refactoring of code unrelated to the reported issues.
