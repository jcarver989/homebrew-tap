class ClankervmServer < Formula
  desc "Hook server for supervising commands in AWS Lambda MicroVMs"
  homepage "https://github.com/jcarver989/clankervm"
  version "0.1.7"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-server-v0.1.7/clankervm-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8812da22961e13c2bb4576ce6933bb974b83af1eafdc98ec21825af2570d18ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jcarver989/clankervm/releases/download/clankervm-server-v0.1.7/clankervm-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aef5100bd177c48f8b06a9d934c31ee4680d2f51fd2623214ae8885ca96ae671"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
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
    if OS.linux? && Hardware::CPU.arm?
      bin.install "clankervm-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "clankervm-server"
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
