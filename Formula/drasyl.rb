class Drasyl < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  version "0.5.0"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v#{version}/drasyl-#{version}.zip"
  sha256 "ce1f869827be503a9aab73347233e5fd3c152ac12e6f2c69a95ac91eb4ff3a21"
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
