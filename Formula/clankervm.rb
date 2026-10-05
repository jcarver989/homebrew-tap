class Clankervm < Formula
  desc "Build and run arbitrary commands in AWS Lambda MicroVMs"
  homepage "https://github.com/jcarver989/clankervm"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.8/clankervm-aarch64-apple-darwin.tar.xz"
      sha256 "5cbd3d165e1addf6b1661b425a638be95361ab833c54f993c0d592eaf3c46f61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.8/clankervm-x86_64-apple-darwin.tar.xz"
      sha256 "973f4968fa2e8d99dc0fb606ef2cf6fc2eac86dd3486d4d5311f251c7e6ff890"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.8/clankervm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45d19f6852be19ee430a5b2a303c5fd023c0ef386ec109395fbd1467a81da24a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-v0.1.8/clankervm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07778d3a92a0e02bc3b6f43d8a596235c9bc5eb3bc578d63dbb3b7aa4a0eae42"
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
