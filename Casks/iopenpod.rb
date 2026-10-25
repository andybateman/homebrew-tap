cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.16"
  sha256 arm:   "95fdc0264cd26cd50c0fcd54e434795bde88d4236cde059afe2b960f6bfbd1b5",
         intel: "4c1d99848aeb675f81a4576daa3cfff73c9dc1cfe96b0a14a9c3a3866f1a7210"

  url "https://github.com/TheRealSavi/iOpenPod/releases/download/v#{version}/iOpenPod-#{version}-macOS-#{arch}.dmg"
  name "iOpenPod"
  desc "Open-source iPod manager and iTunes alternative"
  homepage "https://github.com/TheRealSavi/iOpenPod"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "iOpenPod.app"

  # Release builds are ad-hoc signed and not notarised, so Gatekeeper blocks them.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/iOpenPod.app"],
        writable_paths: ["{{appdir}}/iOpenPod.app"]
  end

  zap trash: "~/Library/Application Support/iOpenPod"
end
