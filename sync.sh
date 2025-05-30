#!/usr/bin/env bash
# Enhanced sync script for sigma productivity workflow
# Usage: ./sync.sh [--force] [--silent] [--check] [--watch]
set -e

FORCE=false
SILENT=false
CHECK_ONLY=false
WATCH_MODE=false

# Parse arguments
for arg in "$@"; do
  case $arg in
  --force)
    FORCE=true
    shift
    ;;
  --silent)
    SILENT=true
    shift
    ;;
  --check)
    CHECK_ONLY=true
    shift
    ;;
  --watch)
    WATCH_MODE=true
    shift
    ;;
  *) # Handle unknown arguments gracefully
    echo "Unknown argument: $arg"
    exit 1
    ;;
  esac
done

# Basic file existence check
check_files() {
  # Check if configuration file exists
  if [ ! -f ~/wlmrNix/c.nix ]; then
    echo "❌ Configuration file c.nix not found!"
    return 1
  fi
  return 0
}

# Function to sync and rebuild
sync_and_rebuild() {
  local auto_rebuild=${1:-false}

  if [[ $SILENT == false ]]; then
    echo "🚀 [$(date '+%H:%M:%S')] Syncing NixOS configuration..."
  fi

  # Ensure we're in the right directory
  if [ ! -d ~/wlmrNix ]; then
    echo "❌ ~/wlmrNix directory not found! Run the setup script first."
    return 1
  fi

  cd ~/wlmrNix

  # Copy hardware config if it doesn't exist in our repo
  if [ ! -f ~/wlmrNix/hardware-configuration.nix ]; then
    if [ -f /etc/nixos/hardware-configuration.nix ]; then
      cp /etc/nixos/hardware-configuration.nix ~/wlmrNix/
      [[ $SILENT == false ]] && echo "✅ Copied hardware-configuration.nix"
    else
      echo "⚠️ Warning: No hardware-configuration.nix found in /etc/nixos/"
      echo "🔧 You may need to generate it with: sudo nixos-generate-config"
    fi
  fi

  # Sync our configs to /etc/nixos/
  sudo cp ~/wlmrNix/c.nix /etc/nixos/configuration.nix

  # Only copy h.nix if it's being used
  if grep -q "import ./h.nix" ~/wlmrNix/c.nix; then
    sudo cp ~/wlmrNix/h.nix /etc/nixos/
  fi

  if [ -f ~/wlmrNix/hardware-configuration.nix ]; then
    sudo cp ~/wlmrNix/hardware-configuration.nix /etc/nixos/
  fi

  [[ $SILENT == false ]] && echo "✅ Configuration files synced!"

  # Basic file check
  if ! check_files; then
    echo "❌ File check failed. Aborting."
    return 1
  fi

  # Auto-rebuild logic
  if [[ $auto_rebuild == true ]] || [[ $FORCE == true ]]; then
    [[ $SILENT == false ]] && echo "🔧 [$(date '+%H:%M:%S')] Auto-rebuilding system..."
    if sudo nixos-rebuild switch; then
      if [[ $SILENT == false ]]; then
        echo "✅ [$(date '+%H:%M:%S')] System rebuilt successfully!"
        echo "🎯 Ready to grind! Your NixOS is updated."
      fi
    else
      echo "❌ Rebuild failed! Check the error messages above."
      return 1
    fi
  elif [[ $WATCH_MODE == false ]]; then
    # Ask if user wants to rebuild (original behavior, but only in non-watch mode)
    read -p "🔧 Rebuild system now? (y/N): " -n 1 -r
    echo # Newline after read -p
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "🚀 Rebuilding system..."
      if sudo nixos-rebuild switch; then
        echo "✅ System rebuilt successfully!"
      else
        echo "❌ Rebuild failed! Check the error messages above."
        return 1
      fi
    else
      echo "⏭️ Skipping rebuild. Run 'sudo nixos-rebuild switch' manually when ready."
    fi
  fi

  # Auto-commit changes if in git repo
  if [[ -d .git ]] && [[ $FORCE == true ]] && [[ $SILENT == false ]]; then
    echo "📝 Auto-committing changes..."
    git add . 2>/dev/null || true
    git commit -m "Auto-update: $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || echo "Nothing to commit"
  fi

  return 0
}

# Function to watch for file changes
watch_files() {
  echo "👀 [$(date '+%H:%M:%S')] Watching ~/wlmrNix for changes..."
  echo "🛑 Press Ctrl+C to stop watching"

  # Check if inotifywait is available
  if ! command -v inotifywait &>/dev/null; then
    echo "❌ inotifywait not found! Install inotify-tools:"
    echo "🔧 Add 'inotify-tools' to your NixOS configuration"
    exit 1
  fi

  # Initial sync
  sync_and_rebuild false

  # Watch for changes (modify, create, delete, move)
  inotifywait -m -r -e modify,create,delete,move ~/wlmrNix --format '%w%f %e' |
    while read file event; do
      # Skip temporary files and hidden files
      if [[ "$file" == *"~" ]] || [[ "$file" == *".swp" ]] || [[ "$file" == *"/.git/"* ]]; then
        continue
      fi

      # Only process .nix files
      if [[ "$file" == *.nix ]]; then
        echo "📝 [$(date '+%H:%M:%S')] Detected change: $file ($event)"

        # Debounce: wait a bit for multiple rapid changes
        sleep 1

        # Auto-sync and rebuild
        if sync_and_rebuild true; then
          echo "🔄 [$(date '+%H:%M:%S')] Auto-sync completed!"
        else
          echo "❌ [$(date '+%H:%M:%S')] Auto-sync failed!"
        fi
        echo "👀 Continuing to watch for changes..."
      fi
    done
}

# Main execution logic
if [[ $WATCH_MODE == true ]]; then
  watch_files
  exit 0
fi

if [[ $SILENT == false ]]; then
  echo "🚀 [$(date '+%H:%M:%S')] Syncing NixOS configuration..."
fi

# Ensure we're in the right directory
if [ ! -d ~/wlmrNix ]; then
  echo "❌ ~/wlmrNix directory not found! Run the setup script first."
  exit 1
fi

cd ~/wlmrNix

# Copy hardware config if it doesn't exist in our repo
if [ ! -f ~/wlmrNix/hardware-configuration.nix ]; then
  if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix ~/wlmrNix/
    [[ $SILENT == false ]] && echo "✅ Copied hardware-configuration.nix"
  else
    echo "⚠️ Warning: No hardware-configuration.nix found in /etc/nixos/"
    echo "🔧 You may need to generate it with: sudo nixos-generate-config"
  fi
fi

# Sync our configs to /etc/nixos/
sudo cp ~/wlmrNix/c.nix /etc/nixos/configuration.nix

# Only copy h.nix if it's being used
if grep -q "import ./h.nix" ~/wlmrNix/c.nix; then
  sudo cp ~/wlmrNix/h.nix /etc/nixos/
fi

if [ -f ~/wlmrNix/hardware-configuration.nix ]; then
  sudo cp ~/wlmrNix/hardware-configuration.nix /etc/nixos/
fi

[[ $SILENT == false ]] && echo "✅ Configuration files synced!"

# Basic file check
if ! check_files; then
  echo "❌ File check failed. Aborting."
  exit 1
fi

# If only checking, exit here
if [[ $CHECK_ONLY == true ]]; then
  echo "✅ Configuration check completed successfully!"
  exit 0
fi

# Auto-rebuild logic
if [[ $FORCE == true ]]; then
  [[ $SILENT == false ]] && echo "🔧 [$(date '+%H:%M:%S')] Force rebuilding system..."
  if sudo nixos-rebuild switch; then
    if [[ $SILENT == false ]]; then
      echo "✅ [$(date '+%H:%M:%S')] System rebuilt successfully!"
      echo "🎯 Ready to grind! Your NixOS is updated."
    fi
  else
    echo "❌ Rebuild failed! Check the error messages above."
    exit 1
  fi
else
  # Ask if user wants to rebuild (original behavior)
  read -p "🔧 Rebuild system now? (y/N): " -n 1 -r
  echo # Newline after read -p
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Rebuilding system..."
    if sudo nixos-rebuild switch; then
      echo "✅ System rebuilt successfully!"
    else
      echo "❌ Rebuild failed! Check the error messages above."
      exit 1
    fi
  else
    echo "⏭️ Skipping rebuild. Run 'sudo nixos-rebuild switch' manually when ready."
  fi
fi

# Auto-commit changes if in git repo
if [[ -d .git ]] && [[ $FORCE == true ]] && [[ $SILENT == false ]]; then
  echo "📝 Auto-committing changes..."
  git add . 2>/dev/null || true
  git commit -m "Auto-update: $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || echo "Nothing to commit"
fi
