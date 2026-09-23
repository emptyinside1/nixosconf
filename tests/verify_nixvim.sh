#!/usr/bin/env bash
# Verification test script for Nixvim IDE Migration (AC-001 - AC-004)
# Worktree: /home/daniil/.nixos/.worktrees/nixvim
# Spec: SPEC-NIXVIM-001

set -u

BASE_DIR="${BASE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
FAILED_CHECKS=()

echo "=== STARTING NIXVIM VERIFICATION TESTS (SPEC-NIXVIM-001) ==="

check_fail() {
    local name="$1"
    local reason="$2"
    echo "[-] FAILED: $name - $reason"
    FAILED_CHECKS+=("$name: $reason")
}

check_pass() {
    local name="$1"
    echo "[+] PASSED: $name"
}

# --- AC-001: Nixvim Flake input & Home Manager module integration ---
echo "--- [AC-001] Checking Nixvim Flake input & HM module integration ---"
FLAKE_FILE="$BASE_DIR/flake.nix"
if grep -q "github:nix-community/nixvim" "$FLAKE_FILE"; then
    check_pass "AC-001 (Nixvim flake input present)"
else
    check_fail "AC-001" "flake.nix does not contain nixvim input (github:nix-community/nixvim)"
fi

# Evaluation of programs.nixvim.enable
NIXVIM_ENABLE_VAL=$(nix eval --extra-experimental-features 'nix-command flakes' "$BASE_DIR#nixosConfigurations.nixos.config.home-manager.users.daniil.programs.nixvim.enable" 2>/dev/null | tail -n1 || true)
if [[ "$NIXVIM_ENABLE_VAL" == "true" ]]; then
    check_pass "AC-001 (programs.nixvim.enable evaluates to true)"
else
    check_fail "AC-001" "programs.nixvim.enable failed to evaluate to true (got: $NIXVIM_ENABLE_VAL)"
fi

# --- AC-002: Modular Nixvim configuration in modules/home/nixvim ---
echo "--- [AC-002] Checking modular Nixvim configuration structure ---"
NIXVIM_DIR="$BASE_DIR/modules/home/nixvim"
REQUIRED_MODULES=(
    "default.nix"
    "options.nix"
    "keymaps.nix"
    "plugins/lsp.nix"
    "plugins/completion.nix"
    "plugins/treesitter.nix"
    "plugins/telescope.nix"
    "plugins/ui.nix"
)

if [[ -d "$NIXVIM_DIR" ]]; then
    MISSING_MODS=()
    for mod in "${REQUIRED_MODULES[@]}"; do
        if [[ ! -f "$NIXVIM_DIR/$mod" ]]; then
            MISSING_MODS+=("$mod")
        fi
    done

    if [[ ${#MISSING_MODS[@]} -eq 0 ]]; then
        check_pass "AC-002 (All Nixvim modular files present in modules/home/nixvim)"
    else
        check_fail "AC-002" "Missing Nixvim module files: ${MISSING_MODS[*]}"
    fi
else
    check_fail "AC-002" "Directory $NIXVIM_DIR does not exist"
fi

# --- AC-003: Core Plugins configured (LSP, Completion, Treesitter, Telescope, UI) ---
echo "--- [AC-003] Checking core plugins configuration in Nixvim eval ---"
CHECK_PLUGINS=(
    "lsp.enable"
    "cmp.enable"
    "treesitter.enable"
    "telescope.enable"
)

for plugin in "${CHECK_PLUGINS[@]}"; do
    PLUGIN_VAL=$(nix eval --extra-experimental-features 'nix-command flakes' "$BASE_DIR#nixosConfigurations.nixos.config.home-manager.users.daniil.programs.nixvim.plugins.$plugin" 2>/dev/null | tail -n1 || true)
    if [[ "$PLUGIN_VAL" == "true" ]]; then
        check_pass "AC-003 (plugins.$plugin is true)"
    else
        check_fail "AC-003" "plugins.$plugin failed to evaluate to true (got: $PLUGIN_VAL)"
    fi
done

# --- AC-004: Clean replacement of legacy neovim module ---
echo "--- [AC-004] Checking legacy neovim module decommission & defaultEditor setting ---"
# Legacy programs.neovim.enable must be disabled or replaced by programs.nixvim.defaultEditor
DEF_EDITOR_VAL=$(nix eval --extra-experimental-features 'nix-command flakes' "$BASE_DIR#nixosConfigurations.nixos.config.home-manager.users.daniil.programs.nixvim.defaultEditor" 2>/dev/null | tail -n1 || true)
if [[ "$DEF_EDITOR_VAL" == "true" ]]; then
    check_pass "AC-004 (programs.nixvim.defaultEditor is true)"
else
    check_fail "AC-004" "programs.nixvim.defaultEditor is not set to true (got: $DEF_EDITOR_VAL)"
fi

# Legacy programs.neovim must not conflict
LEGACY_NVIM_VAL=$(nix eval --extra-experimental-features 'nix-command flakes' "$BASE_DIR#nixosConfigurations.nixos.config.home-manager.users.daniil.programs.neovim.enable" 2>/dev/null | tail -n1 || true)
if [[ "$LEGACY_NVIM_VAL" == "false" ]] || [[ "$LEGACY_NVIM_VAL" =~ error ]]; then
    check_pass "AC-004 (legacy programs.neovim is disabled or removed)"
else
    check_fail "AC-004" "legacy programs.neovim.enable is still true ($LEGACY_NVIM_VAL), expected replacement by nixvim"
fi

# --- SUMMARY & EXIT STATUS ---
echo "========================================="
echo "Total Failures: ${#FAILED_CHECKS[@]}"
if [[ ${#FAILED_CHECKS[@]} -gt 0 ]]; then
    echo "RED PHASE CONFIRMED (Test suite failed as expected for unapplied Nixvim implementation):"
    for err in "${FAILED_CHECKS[@]}"; do
        echo "  - $err"
    done
    exit 1
else
    echo "GREEN PHASE CONFIRMED (All AC-001..AC-004 checks passed!)"
    exit 0
fi
