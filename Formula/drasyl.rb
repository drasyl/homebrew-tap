class Drasyl < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v0.4.1/drasyl-0.4.1.zip"
  sha256 "214dd541367c383130ee99ed101f7d02af607a8a5fbd20db6b0a96d2cb99c45e"
  license "LGPL-3.0"

  livecheck do
    url "https://github.com/drasyl-overlay/drasyl/releases"
    regex(/drasyl-(\d+(?:\.\d+)+).zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    (bin/"drasyl").write_env_script "#{libexec}/bin/drasyl", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/drasyl help")
    assert_match "Run a drasyl node.", output
  end
end
