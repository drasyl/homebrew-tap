class DrasylJava < Formula
  desc "Toolkit for various drasyl-related tasks"
  homepage "https://drasyl.org/"
  version "0.12.0"
  url "https://github.com/drasyl/drasyl/releases/download/v#{version}/drasyl-#{version}.zip"
  sha256 "e66511415ee2d5436ae34aa75fa4d5367042ec78b12d6bfff01b53001c7fdad8"
  license "MIT"
  head "https://github.com/drasyl/drasyl.git"

  livecheck do
    url "https://github.com/drasyl/drasyl/releases/latest"
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
