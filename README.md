# andybateman/tap

<!-- Project metadata: read by the project tools, hidden when the README is rendered.
**Keywords:** Homebrew, tap, cask, formula, termlogo, SolidCraft, iOpenPod, GitHub releases, GitHub Actions, auto-bump, livecheck, quarantine, Gatekeeper, macOS, MacBook setup, Brewfile
**Status:** Active
**Start Date:** 2026-10-21
**Last Updated:** 2026-11-02
-->

Personal Homebrew tap: Mac apps that publish GitHub releases but have no official cask, plus Andy's own `termlogo` formula.

```bash
brew tap andybateman/tap
brew install --cask andybateman/tap/solidcraft
```

## Casks

| Cask | App | Upstream | Notes |
|---|---|---|---|
| `solidcraft` | SolidCraft.app, plus `solidcraft-cli` on PATH | [tangency-labs/solidcraft](https://github.com/tangency-labs/solidcraft) | Universal build |
| `iopenpod` | iOpenPod.app | [TheRealSavi/iOpenPod](https://github.com/TheRealSavi/iOpenPod) | arm64 and x86_64 builds |

Both upstream builds are ad-hoc signed and not notarised, so each cask clears the
`com.apple.quarantine` flag in `postflight`. Only add apps you trust on that basis.

## Formulae

| Formula | What | Notes |
|---|---|---|
| `termlogo` | Logo interpreter with turtle graphics for the terminal, [andybateman/termlogo](https://github.com/andybateman/termlogo) | Installed from the release tarball; bump the `url` and `sha256` by hand on each termlogo release (the bump workflow handles casks only). Moved here from the termlogo repo's own tap on 2026-11-02. |

```bash
brew install andybateman/tap/termlogo
```

## Formulae

| Formula | Tool | Upstream | Notes |
|---|---|---|---|
| `termlogo` | Logo interpreter with turtle graphics for the terminal (`termlogo` on PATH) | [andybateman/termlogo](https://github.com/andybateman/termlogo) | Python 3.13 tool, MIT; the formula's version is 1.2.0 |

```bash
brew tap andybateman/tap
brew install andybateman/tap/termlogo
termlogo --version
```

`Formula/termlogo.rb` installs the Python package into `libexec` and writes a small `bin/termlogo` wrapper that runs it with Homebrew's `python@3.13`, so the only dependency is `python@3.13`. The formula builds from the tag archive `v1.2.0.tar.gz` with a pinned SHA-256, and its test runs `termlogo --version`. It moved here from the old tap inside the termlogo repo.

The formula is not covered by the scheduled bump, which handles casks only. For a new termlogo release, edit `url` and `sha256` by hand (`curl -sL <tag archive> | shasum -a 256`), update the test's expected version string, then run `brew style Formula/termlogo.rb && brew audit --strict andybateman/tap/termlogo`.

## Keeping casks current

`.github/workflows/bump.yml` runs every six hours (and on demand from the Actions tab). It runs
`.github/scripts/bump.py`, which reads each upstream's latest non-prerelease release, takes the
SHA-256 from GitHub's asset digest (nothing is downloaded) and commits the new version and hashes.
On the Mac, `brew upgrade` then picks the new version up like any other cask.

Check by hand without writing anything:

```bash
python3 .github/scripts/bump.py --dry-run
```

## Adding a cask

1. Write `Casks/<token>.rb`, following the existing two.
2. Add the token, repo and asset name pattern to `CASKS` in `bump.py`.
3. `brew style Casks/<token>.rb && brew audit --cask andybateman/tap/<token>`.
4. Add `cask "andybateman/tap/<token>"` to the MacBook project's Brewfile.

## Location

Source lives here, in the MacBook project (`Projects/20261021_Homebrew_Tap`), as its own git repo
pushed to GitHub. Homebrew's clone is at `$(brew --repo andybateman/tap)`: pull, don't edit, there.
