cask "drasyl-ui" do
  desc "drasyl UI - A graphical user interface for drasyl"
  homepage "https://drasyl.org"
  version "latest"
  sha256 :no_check

  if Hardware::CPU.intel?
    url "https://controller.drasyl.org/drasyl-ui-macos-amd64.zip"
  else
    url "https://controller.drasyl.org/drasyl-ui-macos-arm64.zip"
  end

  name "drasyl-ui"
  app "drasyl UI.app"

  depends_on formula: "drasyl"
end 