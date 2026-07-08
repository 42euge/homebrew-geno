class Geno < Formula
  desc "Geno ecosystem — agentic workspace orchestration"
  homepage "https://github.com/42euge"
  url "https://github.com/42euge/geno-tools/archive/refs/heads/main.tar.gz"
  version "0.1.0"
  sha256 "c4aae58a93f469925528297d963d5f973c7e1806d8812134f4c10f00806e1e1e"
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

    # iterm2 API package needed by geno-tt and geno-vault for iTerm2 orchestration
    system "pipx", "inject", "geno-tt", "iterm2"
    system "pipx", "inject", "geno-vault", "iterm2"
  end

  def caveats
    <<~EOS
      Geno ecosystem installed. Available commands:
        geno-tools   — meta package manager for geno skillsets
        tt           — iTerm2 + workspace orchestration
        geno-vault   — registry sync conductor + web GUI + daemon
        surf         — Chromium agent-side orchestration
        pear         — shared watch library

      To start the workspace GUI + daemon:
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
