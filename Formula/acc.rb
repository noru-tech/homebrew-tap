class Acc < Formula
  desc "Deterministic change control for code written by AI coding agents. Checks each change for independent human approval and emits SARIF and in-toto statements."
  homepage "https://github.com/noru-tech/agent-change-control"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.6.0/agent-change-control-aarch64-apple-darwin.tar.xz"
      sha256 "da8b1e135f684cf2395e1f479706faf03d18a07c7d25c6f95a37a4f5b5be8790"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.6.0/agent-change-control-x86_64-apple-darwin.tar.xz"
      sha256 "df19be039db13f2a1852bfe7b5bcc24db476099d1d3a90a06042c604110529a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.6.0/agent-change-control-aarch64-unknown-linux-musl.tar.xz"
      sha256 "91a86d8dc8f0cc06646fb048f1e76620b7b617edc1a86cdb48299905998bb9cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.6.0/agent-change-control-x86_64-unknown-linux-musl.tar.xz"
      sha256 "214c06838307647d89de039bfa1ab7645eac92d24f0d00d42022d85296e72f42"
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
    bash_completion.install "completions/acc.bash" => "acc"
    zsh_completion.install "completions/_acc"
    fish_completion.install "completions/acc.fish"
    man1.install Dir["man/*.1"]

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
