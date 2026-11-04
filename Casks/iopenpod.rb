cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.1.1"
  sha256 arm:   "fc916d96641ca4b9eddfc850cf1a3347bd243ddce7c978c2203edd4daaa6fbaf",
         intel: "6313c2e56bd8f7a7a869f9ff91baa010cb5f745320f11e5965fc7aae10ef4643"

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
