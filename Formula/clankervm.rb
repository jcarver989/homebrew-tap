class Clankervm < Formula
  desc "Build and run arbitrary commands in AWS Lambda MicroVMs"
  homepage "https://github.com/jcarver989/clankervm"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.1/clankervm-aarch64-apple-darwin.tar.xz"
      sha256 "b273ae7dc5ca6ede9483b44cd75444800891e4cea04f618872964330515efc82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.1/clankervm-x86_64-apple-darwin.tar.xz"
      sha256 "3d0fe6c278757b4074863fc5c379e31dd96461770185623fe1b4f80ddea842de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.1/clankervm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "446a621915fe9ade03bd88ae55fb5bc3d29d62adf3668e6334ee8c07596f38b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.1/clankervm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5f48e18a5ba2a53b6593e4d4e6ef19d2ddf1f512f61052f77c50ebad9cb9b52"
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
