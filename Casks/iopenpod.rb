cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.1.3"
  sha256 arm:   "4e3045c7dfbb372812bf98b511c4295a473ef661928540e134276307d7423e5a",
         intel: "f03dc7a17732356427f871f617254c37cfbba1201df33796f7aeba0e37f77bc9"

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
