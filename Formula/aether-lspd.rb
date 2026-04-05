class AetherLspd < Formula
  desc "LSP daemon for sharing language servers across multiple agents"
  homepage "https://github.com/jcarver989/aether"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/v0.1.1/aether-lspd-aarch64-apple-darwin.tar.xz"
    sha256 "c89bdf5c50ea1475023e658e589500a74c86fc058233d3506991fd4298ea6da0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.1/aether-lspd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d4cdd0d1a87241be019625a3d81749bf7d33af88de388ba38ef322ea45e6347"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.1/aether-lspd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f16d6a42c9407fab82e544dbf15c856e1a0cf40c2094df7f03e92acdf7700d3"
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
    bin.install "aether-lspd" if OS.mac? && Hardware::CPU.arm?
    bin.install "aether-lspd" if OS.linux? && Hardware::CPU.arm?
    bin.install "aether-lspd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
