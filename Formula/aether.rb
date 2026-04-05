class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/v0.1.1/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "3661c497951f8327f10fc0c76c3bc8e87d568295202a03e2e74879aea6cbfd58"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.1/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00077ca3ca33d8c037adeef771a0fb6df2c3b136e6f087df01ffd604d758c062"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.1/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1b986afeae916d872a90a4c2738460186bdd88287f2d4e382dbbb8bd0b45cba"
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
