class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.1.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.1.10/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8fa7a97c7e6fd2dcf4ae911febdf1c9c6d74bf713c05354c4aad5d6b3a188e62"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.1.10/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "52ccbb3cfbfecf87e926f7aa97ade7729fbdc2e7415a7397c475fa42c0ff751a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.1.10/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40ea053e68682402eacfeeaffa95a11ca81115c0953af5aaa66a2128af142523"
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
