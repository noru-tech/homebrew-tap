class Crisk < Formula
  desc "Deterministic change risk tiers from changed paths, a sensitivity map and declared facts, as an in-toto predicate."
  homepage "https://github.com/noru-tech/change-risk"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.2.0/change-risk-aarch64-apple-darwin.tar.xz"
      sha256 "b5569fa9f041675f4f04cc61cac48782d730016e037ab66053d44ccdb53bd6c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.2.0/change-risk-x86_64-apple-darwin.tar.xz"
      sha256 "795afdb1be50f1bb34b31292902ff906e26a76f93bde03a0f193c786a70e5a95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.2.0/change-risk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "13e12b3c93019ed1d27e52085c38ec0e9f5fcc2ab3619d3bc8d2bc3436f63fc9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.2.0/change-risk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9c5cfc03beec0b6f1d550ec446231a651ecec6cbbfcc5d25fc4191a1d4562827"
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
      bin.install "crisk"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "crisk"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "crisk"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crisk"
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
