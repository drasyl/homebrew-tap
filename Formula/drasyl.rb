class Drasyl < Formula
  desc "general-purpose overlay network framework for rapid development of distributed P2P applications"
  homepage "https://drasyl.org/"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v0.3.0/drasyl-0.3.0.zip"
  sha256 "a9bb1c28729dbe5c672ba567cd22e91be570a7e753346c5311dad90ef7f4d953"
  license "LGPL-3.0"

  livecheck do
    url "https://github.com/drasyl-overlay/drasyl/releases"
    regex(/drasyl\-(\d+(?:\.\d+)+).zip/)
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