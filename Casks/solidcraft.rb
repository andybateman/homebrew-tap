cask "solidcraft" do
  version "0.26.1"
  sha256 "d816d6ce8acbf1ef7d47937c1a5ef02684b6a0b5d8265ffe185d442130423832"

  url "https://github.com/tangency-labs/solidcraft/releases/download/v#{version}/solidcraft-#{version}-macos-universal.dmg"
  name "SolidCraft"
  desc "Open-source parametric 3D CAD application built in Rust"
  homepage "https://solidcraft.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "SolidCraft.app"
  binary "#{appdir}/SolidCraft.app/Contents/MacOS/solidcraft-cli"

  # Release builds are ad-hoc signed and not notarised, so Gatekeeper blocks them.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/SolidCraft.app"],
        writable_paths: ["{{appdir}}/SolidCraft.app"]
  end

  caveats <<~EOS
    SolidCraft is not notarised. This cask clears the quarantine flag so it opens.
    If you previously had SolveCraft.app, move it to the Bin.
  EOS
end
