cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.17"
  sha256 arm:   "34116f7b81bf3eba024987173a1dd76fb7c5e7e7e1cb6bcdb9d03918db69ba4e",
         intel: "165105362bf172c8216b3066939fee81b6193e573d994a3cc2e807ee07969824"

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
