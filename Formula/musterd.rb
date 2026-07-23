# frozen_string_literal: true

# Homebrew formula for musterd (ADR 156) — npm package via registry tarball.
# Source of truth in the musterd monorepo; copy to SandRiseStudio/homebrew-musterd as Formula/musterd.rb
#
#   brew tap SandRiseStudio/musterd
#   brew trust sandrisestudio/musterd   # first time (Homebrew tap trust)
#   brew install musterd
#
# After an npm publish:
#   pnpm bump-brew-formula --version X.Y.Z

class Musterd < Formula
  desc "Muster your agents and humans into persistent teams"
  homepage "https://github.com/SandRiseStudio/musterd"
  url "https://registry.npmjs.org/@musterd/cli/-/cli-0.3.1.tgz"
  sha256 "7e96ff7184ca0eb1d8e2b038fc695b18988755e1c809c560e4b4dc073c846745"
  license "MIT"

  depends_on "node"

  def install
    # std_npm_args sets npm's --min-release-age (supply-chain delay). Fresh @musterd/*
    # publishes fail that check for hours/days; this tap opts out so brew tracks npm immediately.
    # Revisit before homebrew-core.
    system "npm", "install", "-ddd", "--global", "--build-from-source",
           "--cache=#{HOMEBREW_CACHE}/npm_cache",
           "--prefix=#{libexec}",
           "--min-release-age=0",
           cached_download
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      musterd requires Node >=22.

      Next:
        musterd init

      Upgrade:
        brew upgrade musterd

      Packaged installs cannot `musterd service refresh` (that rebuilds a git checkout).
      Use `brew upgrade musterd` instead.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/musterd --version")
  end
end
