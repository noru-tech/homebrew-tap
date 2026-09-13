class Fl < Formula
  desc "fl — a command-line toolbox for Fideslang privacy taxonomies and Fides manifests: browse, visualize, convert, merge, validate"
  homepage "https://github.com/noru-tech/fideslang-tools"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.0/fideslang-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f5a561b2f19bdd003fc17b534ba007197792e631623ae4ac10f726c53439edf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.0/fideslang-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1a0e13af939baa3dfb8083f67f0bee3984fe2b24464224ddb49eb02087f06d74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.0/fideslang-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "014534612a9720a2df9e1db21dd67848060c59e94e37cf5d308131549ecc85f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noru-tech/fideslang-tools/releases/download/v0.1.0/fideslang-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "13ed118e5df41a9e1f140c7dbe91d74f9e4227fc993d73c1931d9a71d1a12eb4"
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
