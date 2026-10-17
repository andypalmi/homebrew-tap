class Amicu < Formula
  desc "Manage open LLMs and deploy them as code: locally or on cloud GPUs."
  homepage "https://amicu.dev"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.2/amicu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "faf99255f73a895c7ea53f6e5631f6bea3d027d9e3e74ea3ba39e4ff50ec0f96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.2/amicu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "29dedaaf0b5e282ec82187804a659b0c4a4aadd4c5584030986fce8ce66f7248"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.2/amicu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fcdcbabc80df776851c16b74b7b74055765dc2342153deea5abdb877f27273fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.2/amicu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7c877af09140b59ec93899c37ee7612f485816df6b43c48b8968f6dc30a4f3f9"
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
