# CLAUDE.md

Contributor notes for working on this repo with Claude Code. End users of the
`koin-migration` plugin do not need to read this — it applies when editing the
skill itself.

## Source of truth

**Edit only `skills/di-migration/`.** Specifically:

- `skills/di-migration/SKILL.md`
- `skills/di-migration/references/*.md`
- `skills/di-migration/evals/evals.json`

There are **no root-level mirrors** of these files — the `.skill` bundle is zipped
directly from `skills/di-migration/` into a flat layout. If you see a stray
`SKILL.md` or `references/` at the repo root, it's accidental — delete it.

## After any content change

```bash
./build.sh
```

This syncs source → root, validates `.claude-plugin/plugin.json`, and rebuilds
both `di-migration-skill.skill` and `koin-migration-plugin.zip`. Both are
git-ignored — do not commit them.

## Adding a new migration path

1. Create `skills/di-migration/references/<source>-to-koin.md` following the
   structure of the existing references (start with a "Progressive Migration"
   section, then concept mapping, gradle, bindings, qualifiers, retrieval,
   Android/Compose/KMP/testing)
2. Register it in `skills/di-migration/SKILL.md`:
   - Supported Migration Paths table
   - Frontmatter `description` (so the skill triggers on the new framework's name)
3. Add at least one eval case in `skills/di-migration/evals/evals.json`
4. Run `./build.sh`
5. Bump `version` in `.claude-plugin/plugin.json` (MINOR) and add a `CHANGELOG.md` entry

## Releasing

Versioning, tagging, and publishing are scripted. See [RELEASING.md](./RELEASING.md).
Key rule: `.claude-plugin/plugin.json` `version` and the latest `CHANGELOG.md`
heading must agree before running `./release.sh`.

## Koin / skill content guidance

- Safe DSL interface binding: both `single<Impl>().bind<I>()` and
  `single<Impl>().withOptions { bind<I>() }` are valid — do not "normalize" one
  to the other
- Progressive migration is the recommended approach everywhere: create a new
  Koin module alongside the existing DI setup, move definitions feature by
  feature, never rewrite in place
- For Hilt/Dagger sources, always mention the `koin-android-dagger` bridge for
  coexistence during migration
- Runtime fixes / debugging / best-practice checks are delegated to the
  **Kotzilla MCP Server** (`https://mcp.kotzilla.io/mcp`) — don't duplicate that
  content into the skill, link to the MCP instead
