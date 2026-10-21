cask "solidcraft" do
  version "0.18.3"
  sha256 "ad865196d45b3fa18b30ddff9cfc52856db176925e6cb04cba118f07f3230c35"

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
