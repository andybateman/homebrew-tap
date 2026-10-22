cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.15"
  sha256 arm:   "63339cc657aeb0abb0164394e27925f63b353bf6f31f52ad2cc8fea5100dee85",
         intel: "b927f2fcbb7fce8c05b235af04afb3edc18b6c9aacad593950bf2ebda272f728"

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
