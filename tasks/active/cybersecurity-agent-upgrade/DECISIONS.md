# Decisions

## Decision 1
- **Decision:** Add a standard-library Python router and skill corpus in writable repository paths.
- **Reason:** Inspection found no executable agent architecture, while the intended `.agents/` path is not writable.
- **Alternatives:** Editing `.agents/` was disallowed; replacing the repository with a new application would be unjustified.
- **Consequences:** Router APIs will be usable by a future host but cannot by themselves cause a separate runtime to load skills.

## Decision 2
- **Decision:** Use JSON metadata inside Markdown front matter.
- **Reason:** It is human-readable and machine-parseable without third-party YAML dependencies.
- **Alternatives:** YAML would introduce parser/dependency ambiguity; separate metadata files could drift from skill content.
- **Consequences:** The skill validator enforces this exact metadata format.
