class Piiflow < Formula
  desc "Deterministic, offline static analysis of where personal data goes: logs, third-party SDKs, LLM providers and outbound HTTP. Cited file:line flow paths, SARIF, canonical JSON and Fides egress."
  homepage "https://github.com/noru-tech/privacy-flow"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.2.0/privacy-flow-aarch64-apple-darwin.tar.xz"
      sha256 "5d82fc02c9e6ad4696db87c62e2c67c3302db9b72007b4c8c872518d9e0c245b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.2.0/privacy-flow-x86_64-apple-darwin.tar.xz"
      sha256 "667d0264374835f5cdd4a3b342d4095115226db8db1065951c79d7a9ee27b353"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.2.0/privacy-flow-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1c90b2da233cbd69739515d12b8d1ee63fc42b89fb20ef03421fc345a8e70039"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.2.0/privacy-flow-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8ace8b28c35b0fdc5e5d60b0cf96396a0cb1434cf6e3f1017c60ea29aeb49321"
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
