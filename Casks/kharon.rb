cask "kharon" do
  os macos: "darwin", linux: "linux"
  arch arm: "aarch64", intel: "x86_64"

  version "v1.6.1-dev3"
  sha256 arm:          "6b78ab2fba451aeaca478ac54a775bdfcfe693d2415b85cf1302d1260628b989",
         x86_64_linux: "0e2f8d5a17fdbe7266a0f57559a1e27aa2e5ee07c4390c435c3b197997a3ea85",
         arm64_linux:  "4db74010fda48f68dc30eb4067cbd741ed02bdcf12a77dc7eae9dcc6c3cb3da4"

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
              args:         ["gui/#{Process.uid}/io.vshn.Kharon"],
              must_succeed: false,
            },
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
    <<~EOS
      Run `kharon update` to receive jumphost and cluster information.

      Setup your browser to use Kharon! https://github.com/vshn/kharon/tree/main/docs/setup
    EOS
  end
end
