class Piiflow < Formula
  desc "Deterministic, offline static analysis of where personal data goes: logs, third-party SDKs, LLM providers and outbound HTTP. Cited file:line flow paths, SARIF, canonical JSON and Fides egress."
  homepage "https://github.com/noru-tech/privacy-flow"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.1/privacy-flow-aarch64-apple-darwin.tar.xz"
      sha256 "70e3119ab7927120a26c457ccf94fdf519f6853533ec31d8df5e5227237be1b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.1/privacy-flow-x86_64-apple-darwin.tar.xz"
      sha256 "7c8ccb4e4f81ce95b97263c492b13321a9acea17da9674a04f634f9973d44cec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.1/privacy-flow-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8991d09f6ba3a9c8383c3cd556903b668043e3cfd957896f8b9cf1c4be4d4ce0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.1/privacy-flow-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b8637c96f9554bfa42815cdede75bfad1243b2337321d30a45093189d8bce0b8"
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
