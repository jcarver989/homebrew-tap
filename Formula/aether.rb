class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.3.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.3.1/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "1d23f8e80f58af0276398cfda565855c15fafcdddb455625be72963d5f51482f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.3.1/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39724acc04ee40753425d38115c7147eabc9f27083cd70bf31adcb5d8a9696ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.3.1/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d879c4274971ee1c3da92f78347e3effca75b80cc5b2fcbb0e7687ab397f511"
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
