class Amicu < Formula
  desc "Manage open LLMs and deploy them as code: locally or on cloud GPUs."
  homepage "https://amicu.dev"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.6/amicu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0f1dfd39be762b46a56039ed811ad76177c373bc4a295f805929c2c23ebb857e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.6/amicu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "eda5eac5a2124c6425b951b796f330caffb6f7adfb2624214228549d1e0a68a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.6/amicu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "865b0e46a8f2f8d741d3acb9f7bd918096bc2acb4cde9356bb1218f56c369948"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.6/amicu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7162fb552a31803badcb25661f87136f6a8d5f41dbcbeff6efc227b63ddf310d"
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
