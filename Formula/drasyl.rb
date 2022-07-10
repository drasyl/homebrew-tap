class Drasyl < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  version "0.8.0"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v#{version}/drasyl-#{version}.zip"
  sha256 "9fb0f690967399c7796417e1f0b15eee1c0b23c7ed78f802f4900610651bb069"
  license "MIT"
  head "https://github.com/drasyl-overlay/drasyl.git"

  livecheck do
    url "https://github.com/drasyl-overlay/drasyl/releases"
    regex(/drasyl-(\d+(?:\.\d+)+).zip/i)
  end

  depends_on "openjdk"

  def install
    if build.head?
        system "./mvnw --quiet --projects drasyl-cli --also-make -DskipTests -Dmaven.javadoc.skip=true package"
        system "unzip drasyl-*-SNAPSHOT.zip"
        libexec.install Dir["drasyl-*-SNAPSHOT/bin"], Dir["drasyl-*-SNAPSHOT/lib"]
    else
      rm_f Dir["bin/*.bat"]
      libexec.install %w[bin lib]
    end
    (bin/"drasyl").write_env_script "#{libexec}/bin/drasyl", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/drasyl help")
    assert_match "drasyl Command Line Interface: A collection of utilities for drasyl.", output
  end
end
