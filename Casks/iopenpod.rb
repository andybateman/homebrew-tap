cask "iopenpod" do
  arch arm: "arm64", intel: "x86_64"

  version "2.1.0"
  sha256 arm:   "3521132fb84dc17b354fe77c9784223fe1a69a412edb520477f2f1b55f524a1f",
         intel: "6edf60582e34983ed05558a71f4ebd8c30e3872ef2c5cd7133853626fcd5e4b0"

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
