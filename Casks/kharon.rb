cask "kharon" do
  os macos: "darwin", linux: "linux"
  arch arm: "aarch64", intel: "x86_64"

  version "v1.6.1-dev3"
  sha256 arm:          "4e039e83056ccde20acaff0ac7d90d3929da57ac69eca0144dfbc9f3208d037b",
         x86_64_linux: "1b297fb7ce1260d41077f3ac7dcd7504f661d4599e88f4f5bdd0c49778a2779e",
         arm64_linux:  "34135457401ab92c5dfef6b9d7dafa4067eb32de687ecbe32de1fbdd191c29a1"

  url "https://github.com/vshn/kharon/releases/download/#{version}/kharon-#{os}-#{arch}"
  name "Kharon"
  desc "Kharon ferries your connections safely across SSH jumphosts into private networks."
  homepage "https://github.com/vshn/kharon"

  kharon_binary = "#{staged_path}/kharon-#{os}-#{arch}"

  install_script = &lt;&lt;~SHELL
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

  uninstall launchctl: "io.vshn.Kharon",
            trash: [
              "~/Library/LaunchAgents/io.vshn.kharon.plist",
              "~/Library/Logs/io.vshn.Kharon.err.log",
              "~/Library/Logs/io.vshn.Kharon.out.log",
            ]

  zap trash: [
    "~/Library/Caches/io.vshn.kharon",
    "~/Library/Application Support/io.vshn.kharon",
  ]

  caveats do
    &lt;&lt;~EOS
      Run `kharon update` to receive jumphost and cluster information.

      Setup your browser to use Kharon! https://github.com/vshn/kharon/tree/main/docs/setup
    EOS
  end
end
