# Releasing

Maintainer checklist for cutting a new release of the `koin-migration` plugin.

## Before tagging

- [ ] All intended changes merged into `master`
- [ ] `./build.sh` succeeds locally
- [ ] Local smoke test passes: `claude --plugin-dir .` and run one trigger prompt per migration path you changed
- [ ] At least one eval from `skills/di-migration/evals/evals.json` runs end-to-end on a real sample
- [ ] No uncommitted changes (`git status` clean)

## Version bump

- [ ] Bump `version` in `.claude-plugin/plugin.json` following semver:
  - **MAJOR** — breaking changes to SKILL.md workflow, removed references, incompatible file layout
  - **MINOR** — new migration path, new feature, new reference
  - **PATCH** — fixes, wording, typo, clarifications
- [ ] Add a matching `## [X.Y.Z] - YYYY-MM-DD` section to `CHANGELOG.md` listing user-visible changes
- [ ] Commit: `chore: release vX.Y.Z`

## Publish the release

- [ ] Run `./release.sh` — this tags `vX.Y.Z`, pushes the tag, and creates a GitHub Release with the `.skill` bundle and plugin `.zip` attached
- [ ] Verify the release page shows both assets and the notes rendered from `CHANGELOG.md`

## After release

- [ ] If this is a marketplace-facing change, re-test install from the published Anthropic Plugin Directory entry (once approved)
- [ ] Announce in Koin channels (Slack, Twitter/X, release notes mailing) — optional for PATCH
- [ ] For first-time marketplace submission: submit via https://claude.ai/settings/plugins/submit with the repo URL

## Rolling back

If a release is bad:

- [ ] `gh release delete vX.Y.Z --cleanup-tag` to remove the release and tag
- [ ] Revert the offending commits
- [ ] Cut a PATCH release with the fix

Do **not** force-push over a published tag — consumers may have cached the bundle.
