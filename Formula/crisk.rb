class Crisk < Formula
  desc "Deterministic change risk tiers from changed paths, a sensitivity map and declared facts, as an in-toto predicate."
  homepage "https://github.com/noru-tech/change-risk"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.1.0/change-risk-aarch64-apple-darwin.tar.xz"
      sha256 "1904397ad1308eab7eac191ca302cc31a4588e64e47a6fd36ef680fac2a0bda7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.1.0/change-risk-x86_64-apple-darwin.tar.xz"
      sha256 "a441af03ffdedbcededb6f8d2a1ce69846850e2a88be05fc9ff41298fc4267ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.1.0/change-risk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f976abcfe6f211e2f66b8c65a0fdf054938823ce6324632074af6eddfd783283"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/change-risk/releases/download/v0.1.0/change-risk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "04f527b7f0ff71d7d9a0183f590dcc646191890e912cbc840c97bf3c9bcda926"
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
