# noru-tech/homebrew-tap

Homebrew formulas for Noru's command-line tools: acc and fl.

```bash
brew install noru-tech/tap/acc   # agent-change-control
brew install noru-tech/tap/fl    # fideslang-tools
```

Both work on macOS (Apple Silicon and Intel) and Linux (x86_64 and arm64).

## Formulas

| Formula | Install | What it is | Source |
| --- | --- | --- | --- |
| `acc` | `brew install noru-tech/tap/acc` | Deterministic change control for code written by AI coding agents. Records who authored, operated, reviewed and merged each change, with in-toto attestations. | [noru-tech/agent-change-control](https://github.com/noru-tech/agent-change-control) |
| `fl` | `brew install noru-tech/tap/fl` | Rust CLI for Fideslang privacy taxonomies and Fides manifests. Browse, validate, merge, convert and graph data maps offline. | [noru-tech/fideslang-tools](https://github.com/noru-tech/fideslang-tools) |

## How the formulas are built

[cargo-dist](https://opensource.axo.dev/cargo-dist/) generates each formula and pushes it here
from the tagged release of the source repository. Every formula installs a prebuilt binary from
that repository's GitHub Release and pins it by SHA-256. No formula builds from source or runs an
install script.

To check a binary against its release before you run it, verify the archive's GitHub artifact
attestation:

```bash
gh attestation verify <archive> --repo noru-tech/agent-change-control
gh attestation verify <archive> --repo noru-tech/fideslang-tools
```

## Issues

Open issues in the tool's own repository, not here. The formulas in `Formula/` are generated, so
a change made here is overwritten by the next release.

Maintained by [Noru](https://noru.tech), a continuous compliance platform.
