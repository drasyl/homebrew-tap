cask "drasyl-ui" do
  desc "drasyl UI - A graphical user interface for drasyl"
  homepage "https://drasyl.org"
  version "latest"
  sha256 :no_check

  if Hardware::CPU.intel?
    url "https://controller.drasyl.org/releases/0.1.0/macos-amd64/drasyl%20UI.zip"
  else
    url "https://controller.drasyl.org/releases/0.1.0/macos-arm64/drasyl%20UI.zip"
  end

  name "drasyl-ui"
  app "drasyl UI.app"

  depends_on formula: "drasyl"
end 