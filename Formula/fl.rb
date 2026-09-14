class Fl < Formula
  desc "fl — a command-line toolbox for Fideslang privacy taxonomies and Fides manifests: browse, visualize, convert, merge, validate"
  homepage "https://github.com/noru-tech/fideslang-tools"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.1/fideslang-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7c73eb53f713e7d13ff38ff143bdf8cb6a7d48db78739ebe92b2d251eb7899d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.1/fideslang-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1f84b842b913349ea187b6068fe04fefa0d16e62d4cf4b9f4788b19f5393e1a2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.1/fideslang-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0612e0c160503fef3b485bd9dccfe09bf0582297254554e8f254a1d590e58e56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.1/fideslang-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1252c5026ee2613099712818a6b357087bc71aae917ffc26916fdf0e07b13346"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
