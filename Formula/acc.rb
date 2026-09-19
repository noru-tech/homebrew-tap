class Acc < Formula
  desc "Deterministic change control for software written with coding agents"
  homepage "https://github.com/noru-tech/agent-change-control"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.0/agent-change-control-aarch64-apple-darwin.tar.xz"
      sha256 "befa74716709b3d6c3bfe149aca37149330fa0a546281797690526b19b7e7c22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.0/agent-change-control-x86_64-apple-darwin.tar.xz"
      sha256 "48cc38dbd08efb750b364240c08ad74536c04e32be346a2ee7fea61406521d5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.0/agent-change-control-aarch64-unknown-linux-musl.tar.xz"
      sha256 "60d94ec4f04d8a21c8616acdd2cd32695f905c3c024b0e837fcd806dc9018071"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.3.0/agent-change-control-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7569e151dd4d0b6fba95358218b9fb5ba0dff18e3299dc0a33f20402c8276aea"
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
