class Fl < Formula
  desc "Rust CLI for Fideslang privacy taxonomies and Fides manifests. Browse, validate, merge, convert and graph data maps offline."
  homepage "https://github.com/noru-tech/fideslang-tools"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.3/fideslang-cli-aarch64-apple-darwin.tar.xz"
      sha256 "52c033946fbb6a71d0fc14f2e517ba77448b69146f3f19dbec1137314fa7d51c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.3/fideslang-cli-x86_64-apple-darwin.tar.xz"
      sha256 "75aa862f4176d3fe0b2290b083de82e1b43b0e95a17d9b3cda80f008d5c1e1b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.3/fideslang-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "140cbd32a70d0e1c94116da7ef57dd0e762a8529d76e5c4b124994c849b1a6e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.3/fideslang-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b9bb9653e1120be1649fb54e390d9110b9d8a9e7e7c8d062c14155025b6687f0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
      bin.install "fl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fl"
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
