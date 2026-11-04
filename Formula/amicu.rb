class Amicu < Formula
  desc "Manage open LLMs and deploy them as code: locally or on cloud GPUs."
  homepage "https://amicu.dev"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.5/amicu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c905369b8bdd6837a7dd4fba2f479e297e9332656ce47cbd6f7d220a7e81293d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.5/amicu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "edb4955d13068e7044c382b69585c5fdb561f868fa4668df00b3dd6937b42940"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.5/amicu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "103e714c11382a6acd038dd4977f6dd67348b0d957043c17e9a5d371b706840e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andypalmi/amicu/releases/download/v0.1.5/amicu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4105c3e0ed9136bca20dcc35038912c681493c14ba234ff39792606782f000bb"
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
