class Amicu < Formula
  desc "Manage open LLMs and deploy them as code: locally or on cloud GPUs."
  homepage "https://amicu.dev"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.3/amicu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3ba72f70d15d44722469ef660a219226e07b6be8fcfaa2dad1e5adc1111f10d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.3/amicu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "914647adeb51fa1d2ec767a780b144958a5b465e43ee3f7d9bbd1ed053122a7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.3/amicu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c117386e48f9ee3d50ecfd088e2a0e79f303571eea8b72f947601100c4eee865"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.3/amicu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "810f3c074c82a196c9d00e9dd931e8029a1b2318be9b00fdf951dcc436374c0f"
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
