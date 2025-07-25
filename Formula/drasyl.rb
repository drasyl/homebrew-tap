require "securerandom"
require "etc"

class Drasyl < Formula
  desc "drasyl provides secure, software-defined overlay networks, connecting all your devices"
  homepage "https://drasyl.org"
  version "0.1.0"
  license "MIT"
  head "https://github.com/drasyl/drasyl-rs.git"

  conflicts_with "drasyl-java", because: "both install a `drasyl` binary"

  depends_on "rust" => :build

  # Dynamically determine architecture and set appropriate URL
  if Hardware::CPU.arm?
    url "https://controller.drasyl.org/releases/0.1.0/macos-arm64/drasyl"
  else
    url "https://controller.drasyl.org/releases/0.1.0/macos-amd64/drasyl"
  end

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
    if build.head?
      # Use system clang compiler for C and C++
      ENV["CC"] = "/usr/bin/clang"
      ENV["CXX"] = "/usr/bin/clang++"

      # Build the drasyl-sdn package in release mode with DNS and Prometheus features
      system "cargo", "build", "--package", "drasyl-sdn", "--release", "--features", "dns prometheus"

      # Install the drasyl binary
      bin.install "target/release/drasyl"

      # Create configuration and log directories
      (etc/"drasyl").mkpath
      (var/"log").mkpath
    else
      # Install the pre-built binary for stable releases
      bin.install "drasyl"
      
      # Create configuration and log directories
      (etc/"drasyl").mkpath
      (var/"log").mkpath
    end
  end

  def post_install
    token_file = etc/"drasyl/auth.token"

    # Generate a random auth token if it doesn't already exist
    unless token_file.exist?
      token_file.write(SecureRandom.hex(24))
      chmod 0600, token_file
    end
  end

  def caveats
    <<~EOS
      An API auth token has been created at:
        #{etc}/drasyl/auth.token

      To use drasyl you must copy it into your home directory:
        mkdir -p ~/.drasyl
        cp #{etc}/drasyl/auth.token ~/.drasyl/auth.token
        chmod 600 ~/.drasyl/auth.token
    EOS
  end

  test do
    # Check that the drasyl version command executes successfully
    system "#{bin}/drasyl", "version"
  end
end
