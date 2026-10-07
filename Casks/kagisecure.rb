# Homebrew cask for Kagisecure.
cask "kagisecure" do
  version "0.4.0"
  sha256 "5abbfe0b71d66e20a92f79caa9a48c6eb9c8a6961cfd15f2445f4c9cdb586906"

  # A stable filename with no version in it, so `releases/latest/download/Kagisecure.dmg` is a
  # permanent "always latest" link. `#{version}` appears in the tag, which is where it belongs.
  url "https://github.com/itsucara/kagisecure/releases/download/v#{version}/Kagisecure.dmg"
  name "Kagisecure"
  desc "Local-first password manager that lets agents use secrets without seeing them"
  homepage "https://github.com/itsucara/kagisecure"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself with Sparkle, so `brew upgrade` leaves it alone unless
  # `--greedy` is passed.
  auto_updates true
  depends_on macos: :sequoia

  app "Kagisecure.app"
  # The CLI, the MCP sidecar and the native messaging host ship inside the app bundle,
  # so the cask links them rather than installing second copies.
  binary "#{appdir}/Kagisecure.app/Contents/Helpers/kagisecure"
  binary "#{appdir}/Kagisecure.app/Contents/Helpers/kagisecure-mcp"
  binary "#{appdir}/Kagisecure.app/Contents/Helpers/kagisecure-nmhost"

  uninstall quit: "com.kagisecure.app"

  # `zap` removes what an uninstall deliberately leaves behind. The vault is NOT in this list and
  # must never be: `~/Library/Application Support/kagisecure/default.kagivault` is the user's
  # data, and a package manager that deletes a password vault on `brew uninstall --zap` would be
  # a catastrophe with a one-word invocation. Only the caches, the preferences and the socket
  # directory go.
  zap trash: [
    "~/Library/Application Support/kagisecure/run",
    "~/Library/Caches/com.kagisecure.app",
    "~/Library/HTTPStorages/com.kagisecure.app",
    "~/Library/Preferences/com.kagisecure.app.plist",
    "~/Library/Saved Application State/com.kagisecure.app.savedState",
  ]
end
