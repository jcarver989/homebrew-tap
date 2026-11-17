class Clankervm < Formula
  desc "Build and run arbitrary commands in AWS Lambda MicroVMs"
  homepage "https://github.com/jcarver989/clankervm"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.11/clankervm-aarch64-apple-darwin.tar.xz"
      sha256 "cfc71b11746420a84b12a9ad7254ff936167d20c93af2de7731c5fd697c53bce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.11/clankervm-x86_64-apple-darwin.tar.xz"
      sha256 "96fa41bed2c991d44eb1e66a0e7e75714818375f2b861df9fc4eeb0ab2dbc2b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.11/clankervm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d391a02201592719da40222e85ab3ffd6b39db35c91cea3c8a504308f6d13dbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.11/clankervm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19763c2a8b52eb4a41f07619ab7989966f7cd34738a6e1cdf60ea0da848d4761"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "clankervm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "clankervm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "clankervm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "clankervm"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
