class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.3.0/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "eac2a2b92b48f8e1e5941510ea95054c51e5cf5adc153fa7ba1f7a2a7e9c2657"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.3.0/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "01f946b5891e000dfa37b63aa8d7bc49fd18185a3ea78f3f92b48554f5f35576"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.3.0/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9cb0822211d432bae48dea486369366a516ed24a3eedd4530563403718037c99"
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
