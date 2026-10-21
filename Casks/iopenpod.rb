cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.14"
  sha256 arm:   "b2d1bde82c00dc25364b9543e6484db96428e91aca4459b2141f5bf19524ff9f",
         intel: "9d3f7723ea9a23f1d49b1488694f8908a4a0c36358cf6729365869a26960af09"

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
