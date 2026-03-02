class Ghfs < Formula
  desc "Mount GitHub repositories as a local filesystem"
  homepage "https://github.com/rgodha24/ghfs"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.3/ghfs-aarch64-apple-darwin.tar.xz"
      sha256 "db582f4cb9226327580b181ce2cc98f2a5d58d8732af5afb2726052088c96a25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.3/ghfs-x86_64-apple-darwin.tar.xz"
      sha256 "e0db7cd5f4d321531a087420962f15919a4a2de277dc76f6be640651afe37f75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.3/ghfs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "983733816a8eccc6af6e384b6bfdeed87234f145658cd95c466d470422341957"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.3/ghfs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "023e83b759b37783ebc943771968d09eafa5bcb5341c99c37c0d0dce5605691e"
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
