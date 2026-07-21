class Geno < Formula
  desc "Geno ecosystem — agentic workspace orchestration"
  homepage "https://github.com/42euge"
  url "https://github.com/42euge/geno-tools/archive/refs/heads/main.tar.gz"
  version "0.1.0"
  sha256 "0096bb404eb682f5b8a0e1496d11f7309c3623372684a3b5a4e7bf74923b4fa1"
  license "MIT"

  depends_on "go" => :build
  depends_on "pipx"
  depends_on "python@3.12"

  def install
    # Build and install the `geno` unified entry point from geno-cli.
    resource("geno-cli").stage do
      system "go", "build", "-o", bin/"geno", "./cmd/geno"
    end

    # Install each Python tool into its own pipx venv.
    py = Formula["python@3.12"].opt_bin/"python3.12"
    %w[geno-tools geno-tt geno-vault geno-surf geno-pear geno-specs].each do |tool|
      system "pipx", "install", "git+https://github.com/42euge/#{tool}.git",
             "--force", "--python", py
    end

    # iterm2 needed by geno-tt and geno-vault — non-fatal if already present.
    system "bash", "-c", "pipx inject geno-tt iterm2 || true"
    system "bash", "-c", "pipx inject geno-vault iterm2 || true"
  end

  resource "geno-cli" do
    url "https://github.com/42euge/geno-cli/archive/refs/heads/main.tar.gz"
    sha256 "d10c8032db380ac0d279267c5aba15bc50b3bfbef54cd25510e7575396648613"
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
        geno-specs   — structured execution specs for agents and dev loops

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
    system "geno-specs", "--version"
  end
end
