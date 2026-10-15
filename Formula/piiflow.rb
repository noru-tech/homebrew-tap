class Piiflow < Formula
  desc "Deterministic, offline static analysis of where personal data goes: logs, third-party SDKs, LLM providers and outbound HTTP. Cited file:line flow paths, SARIF, canonical JSON and Fides egress."
  homepage "https://github.com/noru-tech/privacy-flow"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.4.0/privacy-flow-aarch64-apple-darwin.tar.xz"
      sha256 "7cbc3b17f647bb43b0a77cd1c38cd16e33b2a302b2fc6be5b3a33ff4690be117"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.4.0/privacy-flow-x86_64-apple-darwin.tar.xz"
      sha256 "e03ed2dabaaaa98a22bbc26c91699a937ebcf3383d0039a8fb09ec09a84cc3b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.4.0/privacy-flow-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ec95d845e6ea8105fa4b3bf0f55fd9705cc4a0773453bfd2e07e2806fc3b8051"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.4.0/privacy-flow-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2f98500f2cb6be9a582f59aae266b936ef758f473b098da441f41829b03cec32"
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
