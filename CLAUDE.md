# CLAUDE.md

Contributor notes for working on this repo with Claude Code. End users of the
`koin-migration` plugin do not need to read this — it applies when editing the
skill itself.

## Source of truth

Skill content lives under **`skills/di-migration/`**:

- `skills/di-migration/SKILL.md`
- `skills/di-migration/references/*.md`
- `skills/di-migration/evals/evals.json`

Plugin manifests live under **`.claude-plugin/`**:

- `plugin.json` — plugin metadata (name, version, description) used by the
  installed plugin
- `marketplace.json` — makes the repo installable via
  `/plugin marketplace add InsertKoinIO/koin-migration` followed by
  `/plugin install koin-migration@koin-migration`. The marketplace `name`
  becomes the `@marketplace` suffix; each `plugins[].name` must match the
  corresponding `plugin.json` `name`.

There are **no root-level mirrors** of the skill files — the `.skill` bundle is
zipped directly from `skills/di-migration/` into a flat layout. If you see a
stray `SKILL.md` or `references/` at the repo root, it's accidental — delete it.

## After any content change

```bash
./build.sh
```

This validates `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
(including that the plugin name is consistent across both), then rebuilds
`di-migration-skill.skill` and `koin-migration-plugin.zip`. Both artifacts are
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

> Note: adding a new migration path **does not** require touching
> `.claude-plugin/marketplace.json` — that file describes the plugin package,
> not its individual skills. Only update `marketplace.json` if the plugin name
> or repo layout changes.

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
