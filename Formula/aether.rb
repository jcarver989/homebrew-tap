class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.1.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.1.7/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "e5326c245b8309f8bfbbdc81266a0beeb10c0486069bb8a79746b42972901a48"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.1.7/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "900071f1f5bbde318b43af291022f152260c2d46cfd950533201fadc145e7d17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/aether-agent-cli-v0.1.7/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "43b8a90f64c4d3f270614713b9fddb52a92ceff3eafe553cf2308e4189be7de7"
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
