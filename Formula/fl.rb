class Fl < Formula
  desc "Rust CLI for Fideslang privacy taxonomies and Fides manifests. Browse, validate, merge, convert and graph data maps offline."
  homepage "https://github.com/noru-tech/fideslang-tools"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.2/fideslang-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e0be582e28924192220438280a01d863368bda952b9b69411bab12a99490ee65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.2/fideslang-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9f4f4206a295deed350360479383e72e8e587a95c25e65dfb9c78446a920181a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.2/fideslang-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "85e23c81ccf9db1d8d28ad57c2ab5f1d1da8b1c801354cad94eed5b694d3632e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.2/fideslang-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cf7d7fd7edc5e4c4d94c4268042561472bc2205b6545759d608280682a73b203"
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
