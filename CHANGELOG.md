# Changelog - andybateman/tap

## [2026-11-02]

- Added `Formula/termlogo.rb`, moved from the termlogo repo's own tap so there is one tap. Formula bumps are manual.

## [2026-10-21] - Tap created

- Casks for SolidCraft 0.18.2 (app and `solidcraft-cli`) and iOpenPod 2.0.14.
- Scheduled GitHub Action bumps both from upstream releases using GitHub asset digests. First manual run succeeded with nothing to bump.
- Casks use `postflight_steps` with `{{appdir}}` tokens (current Homebrew style); iOpenPod declares its macOS 12 minimum. `brew style` and `brew audit --online` pass.
- `bump.py` tested by rolling both casks back on a scratch copy: it restored the exact versions and hashes.
