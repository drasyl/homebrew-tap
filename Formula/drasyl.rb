class Drasyl < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  version "0.9.0"
  url "https://github.com/drasyl-overlay/drasyl/releases/download/v#{version}/drasyl-#{version}.zip"
  sha256 "423cde4a54fc442d312b2b85d66c757ec9494c6b892979d2e2b647e7cdf3fc08"
  license "MIT"
  head "https://github.com/drasyl-overlay/drasyl.git"

  livecheck do
    url "https://github.com/drasyl-overlay/drasyl/releases/latest"
    regex(/<title>.*?v(\d+(?:\.\d+)+).*?<\/title>/i)
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
    output = shell_output("#{bin}/drasyl version")
    assert_match /drasyl-cli.version #{version} \([a-f0-9]{7}\)/, output
  end
end
