class AetherLspd < Formula
  desc "LSP daemon for sharing language servers across multiple agents"
  homepage "https://github.com/contextbridge/aether"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/v0.1.1/aether-lspd-aarch64-apple-darwin.tar.xz"
    sha256 "869f7745ce08c02d6dc1359e9000c802332b9d33cdb2267a092a0e3156590993"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/v0.1.1/aether-lspd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c188b944bb422bb1c8a85da436cdd2026c22127f29bd782ba34a0d0ce49e7ab6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/v0.1.1/aether-lspd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9904569f2873e1c7538195af6e897b309f04eae1c1e8a4cb1f649d1456dcce4d"
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
