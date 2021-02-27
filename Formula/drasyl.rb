class Drasyl < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v0.4.0/drasyl-0.4.0.zip"
  sha256 "a11a42b5021db24d8f7d1294026e8706645616a596d83bd97c4fdc889b9ed888"
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
