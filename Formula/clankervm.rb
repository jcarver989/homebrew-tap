class Clankervm < Formula
  desc "Build and run arbitrary commands in AWS Lambda MicroVMs"
  homepage "https://github.com/jcarver989/clankervm"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.5/clankervm-aarch64-apple-darwin.tar.xz"
      sha256 "2576956968dd326d22cd5de85bd29fd677f1a4cc7a2b7db1fb512793d607c52e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.5/clankervm-x86_64-apple-darwin.tar.xz"
      sha256 "a4942ca94ef36cf749d65f607be741be40612706842052502380615b0e3b1c7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.5/clankervm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "32f10ecef7e40c9a69d71aeb92259b9f029b405e31ba81eab7b9e8afb3957aac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.5/clankervm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7dfca9d13942b1d2b2de25bc67e85f2c048b4d34e699ab2d850dae944ad9835c"
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
