class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/jcarver989/aether"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jcarver989/aether/releases/download/v0.1.5/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "52badeb5519762394b62312c40671cf400c0071b1cdb4dcbe0ddf2da25b7157e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.5/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ec5f8fcbfe09d13853fef9a2cec83adfd24abd5b3dd82024d42899b6831600f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/aether/releases/download/v0.1.5/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8536cd8e5a35bb6db2539079e036db7d27390aa889caba5f64af3c7c1da2bf81"
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
