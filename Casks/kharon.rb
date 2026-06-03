cask "kharon" do
  os macos: "darwin", linux: "linux"
  arch arm: "aarch64", intel: "x86_64"

  version "v1.7.0"
  sha256 arm:          "f396e7064f6fbbd77c69728b91078c1b7572085c61b2157b668f4978646812d8",
         x86_64_linux: "326e39d5d658b578c762b50a9ddd9347f2c59d94f8ae07720e3bd08ce2a0beb5",
         arm64_linux:  "dfd201c655445ef16b31a97c976195894c111ee9a43de69d0551eee6d049a841"

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
