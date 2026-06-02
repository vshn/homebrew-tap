cask "kharon" do
  os macos: "darwin", linux: "linux"
  arch arm: "aarch64", intel: "x86_64"

  version "v1.6.0"
  sha256 arm:          "ddb8f7f47f152bf593e4a3cd8c5f312ee2214124899a98f5230de8e269a7c9f7",
         x86_64_linux: "4d313154d93309ab6580103ee1b5e89f370c84241a4b7277088564fccb4cd8dd",
         arm64_linux:  "c2685b4889d64370559e35bff6d1bfe1021754caaf23fc988cc691d8ee5faae4"

  url "https://github.com/vshn/kharon/releases/download/#{version}/kharon-#{os}-#{arch}"
  name "Kharon"
  desc "Kharon ferries your connections safely across SSH jumphosts into private networks."
  homepage "https://github.com/vshn/kharon"

  binary "#{staged_path}"

  # No zap stanza required
end
