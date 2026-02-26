class Ghfs < Formula
  desc "Mount GitHub repositories as a local filesystem"
  homepage "https://github.com/rgodha24/ghfs"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.1/ghfs-aarch64-apple-darwin.tar.xz"
      sha256 "2400d9253b5e17ca211014d01c2b75ef6c51ec72c0ebeccc748e99ee31c67098"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.1/ghfs-x86_64-apple-darwin.tar.xz"
      sha256 "0dbd95274ba6a6271d50d52af144df63c902e0442c74556ee09668830db6dc48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.1/ghfs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e344b9c2e57ea6219eef9cd26903d4289382a25d973b7dcfa6a38bba0b25876"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.1/ghfs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13887b6f81c45fc975d507067e44fd91a877e04e73e482b9fbdca5d3c79b5f4e"
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
    bin.install "ghfs" if OS.mac? && Hardware::CPU.arm?
    bin.install "ghfs" if OS.mac? && Hardware::CPU.intel?
    bin.install "ghfs" if OS.linux? && Hardware::CPU.arm?
    bin.install "ghfs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
