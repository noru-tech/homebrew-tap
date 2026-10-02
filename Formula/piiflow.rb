class Piiflow < Formula
  desc "Deterministic, offline static analysis of where personal data goes: logs, third-party SDKs, LLM providers and outbound HTTP. Cited file:line flow paths, SARIF, canonical JSON and Fides egress."
  homepage "https://github.com/noru-tech/privacy-flow"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.1.0/privacy-flow-aarch64-apple-darwin.tar.xz"
      sha256 "6e8639f56e88d6e507789adae778b3083a3152f83ab26224e7bc4dec07fda0f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.1.0/privacy-flow-x86_64-apple-darwin.tar.xz"
      sha256 "0ac5b07f358d05ea88e4992f88170440d33652ac013d7f5ec6addd43d798c887"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.1.0/privacy-flow-aarch64-unknown-linux-musl.tar.xz"
      sha256 "353549c14a75e566de0e4247f1665b231622d8b36f3b3f935d739bcc096ec62c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.1.0/privacy-flow-x86_64-unknown-linux-musl.tar.xz"
      sha256 "80d37368e4cf043138af6563b739f9d3e6c36167450ad9a58096ed329cd039c6"
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
      bin.install "piiflow"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "piiflow"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "piiflow"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "piiflow"
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
