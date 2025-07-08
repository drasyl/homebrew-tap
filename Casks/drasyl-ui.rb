cask "drasyl-ui" do
  desc "drasyl UI - A graphical user interface for drasyl"
  homepage "https://drasyl.org"
  version "latest"
  sha256 :no_check

  url "https://controller.drasyl.org/drasyl-ui-macos-arm64.zip"

  name "drasyl-ui"
  app "drasyl UI.app"

  depends_on formula: "drasyl"
end 