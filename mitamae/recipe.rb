# recipe.rb — cross-platform package installation
#
# Uses mitamae's `package` resource which auto-detects the package manager:
#   - Homebrew on macOS
#   - apt on Debian/Ubuntu Linux
#
# Run via: mitamae local recipe.rb

# --- Helpers ---
def macos?
  node[:platform] == "darwin"
end

def linux?
  node[:platform] == "linux"
end

# --- Core packages ---
# These are needed on all platforms.

package "neovim" do
  not_if "which nvim"
end

package "gh" do
  not_if "which gh"
end

package "tmux" do
  not_if "which tmux"
end

package "ripgrep" do
  not_if "which rg"
end

package "fzf" do
  not_if "which fzf"
end

# --- mise (polyglot version manager) ---
# mise isn't in most distro repos, so install via its official script.
execute "install mise" do
  command "curl -fsSL https://mise.jdx.dev/install.sh | sh"
  not_if "which mise"
end

# --- macOS-only packages ---
if macos?
  # Ghostty is distributed as a macOS app (brew cask)
  execute "install ghostty" do
    command "brew install --cask ghostty"
    not_if "brew list --cask ghostty >/dev/null 2>&1"
  end
end
