#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

FAILED=0

echo "=== Running SPEC-TERMINAL-THEME-003 Verification ==="

# AC-THEME-01: gruvbox disabled
echo -n "Checking AC-THEME-01 (gruvbox colorscheme disabled)... "
gruvbox_val=$(nix eval --json .#nixosConfigurations.nixos.config.home-manager.users.daniil.programs.nixvim.colorschemes.gruvbox.enable 2>/dev/null || echo "eval_error")
if [[ "$gruvbox_val" == "false" ]]; then
    echo "PASS (gruvbox.enable = false)"
else
    echo "FAIL (expected 'false', got '$gruvbox_val')"
    FAILED=1
fi

# AC-THEME-02: lualine theme is 16color or auto
echo -n "Checking AC-THEME-02 (lualine theme is 16color or auto)... "
lualine_theme=$(nix eval --raw .#nixosConfigurations.nixos.config.home-manager.users.daniil.programs.nixvim.plugins.lualine.settings.options.theme 2>/dev/null || echo "eval_error")
if [[ "$lualine_theme" == "16color" || "$lualine_theme" == "auto" ]]; then
    echo "PASS (lualine.theme = '$lualine_theme')"
else
    echo "FAIL (expected '16color' or 'auto', got '$lualine_theme')"
    FAILED=1
fi

if [[ $FAILED -ne 0 ]]; then
    echo "=== TEST RESULT: FAILED ==="
    exit 1
else
    echo "=== TEST RESULT: PASSED ==="
    exit 0
fi
