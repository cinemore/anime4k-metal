class Anime4kMetal < Formula
  desc "Native macOS Anime4K image enhancement CLI"
  homepage "https://github.com/cinemore/anime4k-metal"
  license "MIT"

  depends_on macos: :ventura

  if Hardware::CPU.arm?
    url "https://github.com/cinemore/anime4k-metal/releases/download/v0.1.0/anime4k-metal-macos-arm64.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  else
    url "https://github.com/cinemore/anime4k-metal/releases/download/v0.1.0/anime4k-metal-macos-x86_64.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  end

  def install
    libexec.install "bin/anime4k-metal"
    libexec.install "bin/Anime4KMetal_Anime4KMetalCore.bundle"

    (bin/"anime4k-metal").write <<~SH
      #!/bin/sh
      exec "#{libexec}/anime4k-metal" "$@"
    SH
  end

  test do
    assert_match "Native Apple Metal Anime4K-style image enhancement", shell_output("#{bin}/anime4k-metal --help")
  end
end
