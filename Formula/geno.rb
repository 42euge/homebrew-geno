class Geno < Formula
  desc "Geno ecosystem — agentic workspace orchestration"
  homepage "https://github.com/42euge"
  url "https://github.com/42euge/geno-tools/archive/92756abb1d9422ca44c776e889a31038777a92c9.tar.gz"
  version "0.1.0"
  sha256 "624203ad3167d2938566ae02f29a6c228f3865f2c3a3d7593fac6cf6419e636f"
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

  def post_install
    # Register the geno-tt workspace skillset (the `tt` code-org scheme:
    # ~/code/<track>/<domain>/<workspace>.<born>/<repo>) with all coding agents,
    # and run its SessionStart bootstrap so the workspace-scheme section is
    # injected into the global CLAUDE.md. This supersedes the deprecated
    # color-folder method (geno-ws). Best-effort — never fail the install.
    system "bash", "-c", "command -v geno-tools >/dev/null && geno-tools install geno-tt || true"
    system "bash", "-c", "command -v tt >/dev/null && tt --version >/dev/null 2>&1 || true"
  end

  resource "geno-cli" do
    url "https://github.com/42euge/geno-cli/archive/8cd339416cd0d38d6892e6ea599dc36de28bcbbb.tar.gz"
    sha256 "f3c09da919bb67c8fbe8b5a2daae986794d0ec9f7de0017877a9a80ca31d359c"
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

      Workspaces (the code-org scheme, via `tt`):
        ~/code/<track>/<domain>/<workspace>.<born>/<repo>
        tt new-project <track>.<domain>.<workspace>   # create a workspace
        tt ecosystem-clone <owner> <domain>           # clone a whole org
        tt inv                                        # list workspaces
        tt migrate --apply                            # move old color-folder
                                                      #   workspaces to the scheme
      The legacy geno-ws color-folder method (~/code-<color>/*-ws) is
      DEPRECATED — use the commands above. The workspace scheme is documented
      in ~/.claude/CLAUDE.md (kept current by the geno-tt SessionStart hook).

      To start the workspace daemon:
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
