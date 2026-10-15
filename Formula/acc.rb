class Acc < Formula
  desc "Deterministic change control for code written by AI coding agents. Checks each change for independent human approval and emits SARIF and in-toto statements."
  homepage "https://github.com/noru-tech/agent-change-control"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.7.0/agent-change-control-aarch64-apple-darwin.tar.xz"
      sha256 "d42243961968dafcd79e589e106fa0335e4146ed82ba1080fd750906846c33de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.7.0/agent-change-control-x86_64-apple-darwin.tar.xz"
      sha256 "7399ec82e54b003c130107eafa6078d06037b631283a121a450463880779817a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.7.0/agent-change-control-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4dc1aac932ad453f62f35dd7d546eaf4851cad6728effa4c67a1c7ffad63c5b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/agent-change-control/releases/download/v0.7.0/agent-change-control-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a6637de897235bec9419e7676b6454d03d1703e14f0c3625657a5632009a2ee6"
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
