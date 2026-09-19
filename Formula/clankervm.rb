class Clankervm < Formula
  desc "Build and run arbitrary commands in AWS Lambda MicroVMs"
  homepage "https://github.com/jcarver989/clankervm"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.6/clankervm-aarch64-apple-darwin.tar.xz"
      sha256 "48ec04ff6dff0eb45abcf9279960a7f91e8de571b83ea3dcc123e4c1efdb1359"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.6/clankervm-x86_64-apple-darwin.tar.xz"
      sha256 "eed75215c61f74967f4106f55b320f7e6c67780603f4ab16037d6db426eedfaa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.6/clankervm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bce9c259a740640a3414c131e84cb910a4acaf1ffa65fa78ec6dd2727889903d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.6/clankervm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff9938a60a5d151095a409cfbfc2302d1083489ded3d1235dbb6bdc933c89e6d"
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
