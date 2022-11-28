class Libdrasyl < Formula
  desc "Native Shared Library of drasyl"
  homepage "https://drasyl.org/"
  version "0.9.0"
  license "MIT"

  arch = "arm64"
  platform = "macos"

  on_intel do
    arch = "amd64"
  end

  on_linux do
    platform = "linux"
  end

  checksums = {
    "macos-arm64" => "c936f763b9a8d73fb855176536fe2fd5b853dc536db1e1ec733b31fab057dc5d",
    "macos-amd64" => "f464f4ecb87452c0c0d4697edfadeba17602fd31da86ac4b2f43c2a75e80ac70",
    "linux-arm64"  => "865b01dcdfccf7696b7915e513030ebdc511796ecee5614f8430aba320936b27",
    "linux-amd64"  => "beb04346769b03ed0cb7fd47720a21771727e3d91ffe594375c177370a5b2d4c",
  }

  url "https://github.com/drasyl/drasyl/releases/download/v#{version}/libdrasyl-#{version}-#{platform}-#{arch}.zip"
  sha256 checksums["#{platform}-#{arch}"]

  livecheck do
    url "https://github.com/drasyl/drasyl/releases/latest"
    regex(/<title>.*?v(\d+(?:\.\d+)+).*?<\/title>/i)
  end

  def install
    include.install Dir["*.h"]
    lib_ext = OS.mac? ? "dylib" : "so"
    lib.install Dir["*.#{lib_ext}"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>

      #include "drasyl.h"
      #include "libdrasyl.h"

      int main() {
          graal_isolate_t *isolate = NULL;
          graal_isolatethread_t *thread = NULL;

          if (graal_create_isolate(NULL, &isolate, &thread) != 0) {
              return DRASYL_ERROR_GENERAL;
          }

          int version = drasyl_node_version(thread);
          printf("%i.%i.%i", (version >> 24) & 0xff, (version >> 16) & 0xff, (version >> 8) & 0xff);

          return DRASYL_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-l", "drasyl", "-o", "test"
    assert_equal version, shell_output("./test")
  end
end
