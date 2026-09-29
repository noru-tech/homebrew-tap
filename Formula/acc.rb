class Acc < Formula
  desc "Deterministic change control for software written with coding agents"
  homepage "https://github.com/noru-tech/agent-change-control"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.5.2/agent-change-control-aarch64-apple-darwin.tar.xz"
      sha256 "6cea55beaaeebce352ac8c6e983b7a4c13e4dc459ccded433dc7a6683ade92a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.5.2/agent-change-control-x86_64-apple-darwin.tar.xz"
      sha256 "bc31cdc7428c38cdca7d3605a7e1f473a405df083e0a004b894ac798a965d994"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.5.2/agent-change-control-aarch64-unknown-linux-musl.tar.xz"
      sha256 "53319a7aefe0ee8dbaac8326420b019149c86a4cb77ba69d9de2577f47b1ea8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.5.2/agent-change-control-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cbdc093f2e97042297f8820751b4a4dfc80d65f843365b754269524315231756"
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
      bin.install "acc"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "acc"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "acc"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "acc"
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
