# devoops

Personal macOS development-device setup.

This repository contains a small, personal-only baseline for portable command-line tools, optional development applications, and opt-in shell/Kitty templates. It is intentionally separate from work-owned infrastructure and agent-specific configuration.

## Scope

Included:

- Homebrew formulae for general development work.
- Optional GUI applications for development and personal productivity.
- Sanitized zsh and Kitty starter templates.
- Dry-run-first bootstrap commands.

Excluded:

- Work cloud, VPN, jump-host, Chef, OCI, Kubernetes, Jira, and enterprise aliases.
- Agent runtimes, model configuration, MCP settings, role profiles, and orchestration.
- Secrets, credentials, SSH keys, cloud profiles, personal app data, and machine-specific paths.

## Preview

\`\`\`bash
scripts/bootstrap-mac.sh --list
scripts/bootstrap-mac.sh --dry-run
scripts/bootstrap-mac.sh --include-casks --dry-run
scripts/bootstrap-mac.sh --link-dotfiles --dotfiles-only --dry-run
\`\`\`

Applying packages or linking local configuration requires an explicit \`--apply\` invocation. The script never uninstalls packages and refuses to replace an existing non-symlink target.

See [docs/mac-bootstrap.md](docs/mac-bootstrap.md) for the setup contract and review gates.
