#!/usr/bin/env bash
# bootstrap.sh — download mitamae and run the package recipe
#
# Usage: ./mitamae/bootstrap.sh
#
# Downloads the mitamae binary for the current platform from GitHub releases,
# then runs recipe.rb to install packages.

set -euo pipefail

MITAMAE_VERSION="v1.14.4"
MITAMAE_DIR="$(cd "$(dirname "$0")" && pwd)"
MITAMAE_BIN="${MITAMAE_DIR}/bin/mitamae"

# --- Detect platform ---
detect_platform() {
  local os arch

  case "$(uname -s)" in
    Darwin) os="darwin" ;;
    Linux)  os="linux" ;;
    *)
      echo "Unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac

  case "$(uname -m)" in
    x86_64|amd64)  arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    *)
      echo "Unsupported architecture: $(uname -m)" >&2
      exit 1
      ;;
  esac

  echo "${arch}-${os}"
}

# --- Download mitamae ---
download_mitamae() {
  if [[ -x "${MITAMAE_BIN}" ]]; then
    local current_version
    current_version=$("${MITAMAE_BIN}" version 2>/dev/null || echo "unknown")
    if [[ "${current_version}" == *"${MITAMAE_VERSION#v}"* ]]; then
      echo "✓ mitamae ${MITAMAE_VERSION} already installed"
      return
    fi
  fi

  local platform
  platform="$(detect_platform)"
  local url="https://github.com/itamae-kitchen/mitamae/releases/download/${MITAMAE_VERSION}/mitamae-${platform}"

  echo "→ Downloading mitamae ${MITAMAE_VERSION} for ${platform}..."
  mkdir -p "${MITAMAE_DIR}/bin"
  curl -fsSL -o "${MITAMAE_BIN}" "${url}"
  chmod +x "${MITAMAE_BIN}"
  echo "✓ mitamae installed to ${MITAMAE_BIN}"
}

# --- Main ---
echo ""
echo "  mitamae bootstrap"
echo "  ================="
echo ""

download_mitamae

echo ""
echo "→ Running recipe..."
echo ""

exec "${MITAMAE_BIN}" local "${MITAMAE_DIR}/recipe.rb"
