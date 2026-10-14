class Piiflow < Formula
  desc "Deterministic, offline static analysis of where personal data goes: logs, third-party SDKs, LLM providers and outbound HTTP. Cited file:line flow paths, SARIF, canonical JSON and Fides egress."
  homepage "https://github.com/noru-tech/privacy-flow"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.0/privacy-flow-aarch64-apple-darwin.tar.xz"
      sha256 "06ede2222b0dc2fe4ca4af185a7b4a073e2975318e1b5319b49078bc441026d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.0/privacy-flow-x86_64-apple-darwin.tar.xz"
      sha256 "b196954ebdd7af1ac22fc39e2f6c102b02ec90b22fbac65161a99c700c8305d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.0/privacy-flow-aarch64-unknown-linux-musl.tar.xz"
      sha256 "831bd860b5c769d0e7de9f813adcea7e5e12be949e55a6e04164cce2e2a52fe1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/privacy-flow/releases/download/v0.3.0/privacy-flow-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bbacc7be9b14abd6ca7dd172e555ba4e56c7f60c564bf9ab49b82064225dd531"
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
