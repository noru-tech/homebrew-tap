class Acc < Formula
  desc "Deterministic change control for software written with coding agents"
  homepage "https://github.com/noru-tech/agent-change-control"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.1/agent-change-control-aarch64-apple-darwin.tar.xz"
      sha256 "6ead2f78d4ff034615be3fcf7d7882ac01378739b13dd7c0dc38018bb0f23da9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.1/agent-change-control-x86_64-apple-darwin.tar.xz"
      sha256 "6737532987e662cfbe886b6c7f1bcd75eb6ab027e3eff8e6cdca3e168bef8684"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.1/agent-change-control-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a8bbc0b6435e9a5d3f69a62da77ff94b1d3e23757b0a70d8b7ec2cc3a2a8bac7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.1/agent-change-control-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2cc11c2c135da16df4884df51aa628d964385c554e39f9a18c7f4f43966b1fcf"
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
