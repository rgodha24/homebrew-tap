class Ghfs < Formula
  desc "Mount GitHub repositories as a local filesystem"
  homepage "https://github.com/rgodha24/ghfs"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.2/ghfs-aarch64-apple-darwin.tar.xz"
      sha256 "76e847b6cbeaf7e2692c2e0c234302333cb81236b595c4be25c7b58117875d8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.2/ghfs-x86_64-apple-darwin.tar.xz"
      sha256 "7c0aa969889bbedf038c86ea8e453f2a89b5872d0a737de7e26f95a0bf5e6701"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.2/ghfs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cefa3cca5672a64b3b9e2d64fd27f07c226104ad1b77a351edf42351cfa75d89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rgodha24/ghfs/releases/download/v0.0.2/ghfs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3af014c08de3600d3ffceeacc6bc3477ba4f054feb80c59331ed52da907c6f22"
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
