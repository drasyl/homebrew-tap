class Drasyl < Formula
  desc "Software-defined networking across end hosts, leveraging drasyl for peer communication"
  homepage "https://drasyl.org"
  url "https://github.com/drasyl/drasyl-rs.git", branch: "master"
  version "0.1.0"

  conflicts_with "drasyl-java", because: "both install a `drasyl` binary"

  depends_on "rust" => :build

  service do
    run [opt_bin/"drasyl", "run"]
    keep_alive true
    require_root true
    working_dir etc/"drasyl"
    log_path var/"log/drasyl.out.log"
    error_log_path var/"log/drasyl.err.log"
    environment_variables RUST_LOG: "info"
    environment_variables RUST_BACKTRACE: "full"
  end

  def install
    ENV["CC"] = "/usr/bin/clang"
    ENV["CXX"] = "/usr/bin/clang++"
    system "cargo", "build", "--package", "drasyl-sdn", "--release", "--features", "dns prometheus"
    bin.install "target/release/drasyl"

    (etc/"drasyl").mkpath
    (var/"log").mkpath
  end

  test do
    system "#{bin}/drasyl", "status"
  end
end