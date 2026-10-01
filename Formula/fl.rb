class Fl < Formula
  desc "Rust CLI for Fideslang privacy taxonomies and Fides manifests. Browse, validate, merge, convert and graph data maps offline."
  homepage "https://github.com/noru-tech/fideslang-tools"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.2.0/fideslang-cli-aarch64-apple-darwin.tar.xz"
      sha256 "45f42b87b5554ed87cbc19c351c4f2b269e64f673a9897b3c537e301019e93e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.2.0/fideslang-cli-x86_64-apple-darwin.tar.xz"
      sha256 "324d6ddcd40629b1a052b145fc819b78eac1a35184946d960e4831a04b82e978"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.2.0/fideslang-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a597420ee8d064622fc052429c315f100aa374adce7d5d2a0cab939e5580d230"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.2.0/fideslang-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b49bce1904465f096e0451e7e692d81151068cd5b00950a50bbd63cb8739e24b"
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
      bin.install "fl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fl"
    end

    install_binary_aliases!

    # Shell completions and man pages from the archive (added by fideslang-tools'
    # scripts/homebrew-formula-extras.sh).
    bash_completion.install "completions/fl.bash" => "fl"
    zsh_completion.install "completions/_fl"
    fish_completion.install "completions/fl.fish"
    man1.install Dir["man/*.1"]
    rm_r %w[completions man]

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
