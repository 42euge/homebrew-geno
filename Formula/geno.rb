class Geno < Formula
  desc "Geno ecosystem — agentic workspace orchestration"
  homepage "https://github.com/42euge"
  url "https://github.com/42euge/geno-tools/archive/refs/heads/main.tar.gz"
  version "0.1.0"
  sha256 "0096bb404eb682f5b8a0e1496d11f7309c3623372684a3b5a4e7bf74923b4fa1"
  license "MIT"

  depends_on "pipx"
  depends_on "python@3.12"

  def install
    # Each tool installs into its own pipx venv; pipx manages the PATH links.
    tools = %w[
      geno-tools
      geno-tt
      geno-vault
      geno-surf
      geno-pear
    ]
    tools.each do |tool|
      system "pipx", "install", "git+https://github.com/42euge/#{tool}.git",
             "--force", "--python", Formula["python@3.12"].opt_bin/"python3.12"
    end

    # iterm2 API package needed by geno-tt and geno-vault for iTerm2 orchestration.
    # Use || true so a missing/already-present iterm2 doesn't abort the install.
    system "bash", "-c", "pipx inject geno-tt iterm2 || true"
    system "bash", "-c", "pipx inject geno-vault iterm2 || true"

    # Homebrew requires at least one file in the prefix — write a marker.
    (prefix/"INSTALLED").write "geno ecosystem #{version}\n"
  end

  def caveats
    <<~EOS
      Geno ecosystem installed. Available commands:
        geno         — unified entry point (geno tt / geno vault / geno surf …)
        geno-tools   — meta package manager for geno skillsets
        tt           — iTerm2 + workspace orchestration
        geno-vault   — registry sync conductor + web GUI + daemon
        surf         — Chromium agent-side orchestration
        pear         — shared watch library

      To start the workspace:
        geno-vault serve &   # iTerm2 real-time sync daemon
        geno-vault gui       # opens localhost:8787

      iTerm2 Python API must be enabled:
        iTerm2 ▸ Settings ▸ General ▸ Magic ▸ Enable Python API
    EOS
  end

  test do
    system "geno-tools", "--version"
    system "tt", "--version"
    system "geno-vault", "--help"
  end
end
