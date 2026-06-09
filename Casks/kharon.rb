cask "kharon" do
  os macos: "darwin", linux: "linux"
  arch arm: "aarch64", intel: "x86_64"

  version "v1.7.2"
  sha256 arm:          "b91a1e7bf70f56fddfe4591ec71bc17b4f714ae7c49d566a2b290fef1f8c727b",
         x86_64_linux: "317e4700ab3069e277326c2b395d8bf60b2a8c2064accc99d340446875a43b9a",
         arm64_linux:  "0c7efc3ef5be9bef70c4647cc25f097f9a335174b85386b6cc47f7a817fa1a7e"

  url "https://github.com/vshn/kharon/releases/download/#{version}/kharon-#{os}-#{arch}"
  name "Kharon"
  desc "Kharon ferries your connections safely across SSH jumphosts into private networks."
  homepage "https://github.com/vshn/kharon"

  kharon_binary = "#{staged_path}/kharon-#{os}-#{arch}"

  install_script = <<~SHELL
    if [[ "$(uname -s)" == "Darwin" ]]; then
      xattr -dr com.apple.quarantine '#{kharon_binary}'
      codesign -s - --deep --force '#{kharon_binary}'
    fi
    chmod +x '#{kharon_binary}'
    '#{kharon_binary}' completion bash > '#{staged_path}/kharon-completion.bash'
    '#{kharon_binary}' completion zsh > '#{staged_path}/_kharon'
    '#{kharon_binary}' completion fish > '#{staged_path}/kharon-completion.fish'
    '#{kharon_binary}' install --yes > /dev/null
  SHELL

  installer script: {
    executable: "sh",
    args:       ["-e", "-c", install_script],
  }

  binary kharon_binary, target: "kharon"

  bash_completion "#{staged_path}/kharon-completion.bash", target: "kharon"
  zsh_completion "#{staged_path}/_kharon", target: "_kharon"
  fish_completion "#{staged_path}/kharon-completion.fish", target: "kharon.fish"

  uninstall script: {
              executable:   "/bin/launchctl",
              args:         ["bootout", "gui/#{Process.uid}/io.vshn.Kharon"],
              must_succeed: false,
            },
            trash: [
              "~/Library/LaunchAgents/io.vshn.Kharon.plist",
              "~/Library/Logs/io.vshn.Kharon.err.log",
              "~/Library/Logs/io.vshn.Kharon.out.log",
            ]

  zap trash: [
    "~/Library/Caches/io.vshn.kharon",
    "~/Library/Application Support/io.vshn.kharon",
  ]

  caveats do
    <<~EOS
      Run `kharon update` to receive jumphost and cluster information.

      Setup your browser to use Kharon! https://github.com/vshn/kharon/tree/main/docs/setup
    EOS
  end
end
