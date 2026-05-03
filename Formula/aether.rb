class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.4.0/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "63696407b44765721a63a48133eb31170c1252e0e417e2c1368a03a1735ead31"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.4.0/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b357196e27522daf9470b66f8ffcfc9ed461756be50e63499bdb2051eb4a5935"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.4.0/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e237510de749190975f8516d90a1d361a5641cb047bc32642ff538223e6c732b"
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
