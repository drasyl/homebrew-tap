class Drasyl < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  version "0.5.1"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v#{version}/drasyl-#{version}.zip"
  sha256 "84ac746b8b282620d254037d3a03ce4ab0542c364ecc5519c1c5ff4ffd785641"
  license "MIT"

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
