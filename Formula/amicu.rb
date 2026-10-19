class Amicu < Formula
  desc "Manage open LLMs and deploy them as code: locally or on cloud GPUs."
  homepage "https://amicu.dev"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.4/amicu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "284a9c355bab3f0275edd44150104450489b487bc6af3ad8a49db9d2e601310e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.4/amicu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0219a2ba10e1143c4161dfff6964630525783ce038e71cb84e9b76121bbb4762"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.4/amicu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "362b7f77e75229afce61343136102e5805a707b2243167dc5e902b480e59e0b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.4/amicu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0c5dd7b6eb88cd58c9251fdc12454203479e7716790b1ed3b2092d6441489d00"
    end
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "amicu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "amicu"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "amicu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "amicu"
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
