# Personal Mac bootstrap

This is the personal-device subset of the reviewed Mac bootstrap work. It keeps the useful portable baseline while leaving work-owned and agent-specific setup in its existing boundaries.

## Source of truth

The versioned manifests and templates in this repository are the source of truth for the personal baseline. Each device is a materialized target, not a source that is synchronized directly to another device. Device-specific differences belong in local, untracked overrides and become manifest changes only through review.

## Package policy

- \`config/homebrew/formulae.txt\` contains general development formulae.
- \`config/homebrew/casks.optional.txt\` contains optional GUI applications.
- Nothing is installed by default.
- Legacy enterprise, infrastructure, credential, and VPN tooling is deliberately absent.

## Shell and Kitty policy

Templates are stored under \`dotfiles/\` and can be previewed or linked under \`~/.config/devoops/\`. The bootstrap script does not replace \`~/.zshrc\` or an active Kitty configuration. A user may add an explicit source line to an existing shell configuration after reviewing the rendered files.

Local overrides, if needed, belong only in:

\`\`\`text
~/.config/devoops/shell/local.zsh
~/.config/devoops/kitty/local.conf
\`\`\`

Those files are never tracked by this repository.

## Commands

List the current inventory:

\`\`\`bash
scripts/bootstrap-mac.sh --list
\`\`\`

Preview package actions without inspecting or changing Homebrew:

\`\`\`bash
scripts/bootstrap-mac.sh --dry-run
\`\`\`

Preview optional applications:

\`\`\`bash
scripts/bootstrap-mac.sh --include-casks --dry-run
\`\`\`

Preview template links:

\`\`\`bash
scripts/bootstrap-mac.sh --link-dotfiles --dotfiles-only --dry-run
\`\`\`

Applying packages or links is a separate gate:

\`\`\`bash
scripts/bootstrap-mac.sh --apply
scripts/bootstrap-mac.sh --apply --include-casks
scripts/bootstrap-mac.sh --apply --link-dotfiles --dotfiles-only
\`\`\`

If an apply is later approved, review the dry-run output first and preserve any local configuration that is not represented by this repository. The script refuses to replace existing non-symlink targets.
