class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/v0.1.1/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "7995d65c1c868c0cad13e4d7c97387d545dcf3e1dfda432063e694542e8d529b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/v0.1.1/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7f1ecdb59b25c1aea86e29948ddf9a0e598b98e8ffb097fc9c14bddc71985ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/v0.1.1/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2cadbd87b14560a511f58ef52f8993635b75b9471c96e7344779d7faf66df906"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "aether" if OS.mac? && Hardware::CPU.arm?
    bin.install "aether" if OS.linux? && Hardware::CPU.arm?
    bin.install "aether" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
