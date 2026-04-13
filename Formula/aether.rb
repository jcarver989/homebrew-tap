class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/v0.1.4/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "39480c883a57cc47835885ff02351a49df5d686d20dee3d2aaa49200fab2bbb5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.4/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af33b78e1de65765706dd950157f634ab9a6dc272b9488f2830973adc7077ab1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.4/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09f67b5a9576bfabe5b18de28a1bba298cff6d60f23afae0b52db9ed3de7a825"
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
