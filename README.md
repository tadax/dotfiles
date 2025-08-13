# dotfiles

## Usage

1. Clone the Repository

```bash
git clone https://github.com/yourname/dotfiles.git
cd dotfiles
```

2. Run the Setup Script

`setup_all.sh` runs the OS-specific bootstrap scripts and then calls install.sh to create symlinks for your dotfiles in the home directory.
You only need to run this script - it will handle everything.

```bash
./setup_all.sh --bootstrap --upgrade [--cuda]
```

This will:

- Install required packages (brew for macOS, apt for Ubuntu)
- Configure development tools (git, vim, ssh, etc.)
- Apply OS-specific settings (keyboard, defaults, etc.)
- Create symbolic links for dotfiles (`install.sh` is called automatically)

3. Directory Structure

```
./
├── README.md
├── bootstrap/     # OS-specific setup scripts
├── packages/      # OS-specific configuration files
├── install.sh     # Symlinks dotfiles into $HOME
└── setup_all.sh   # Runs bootstrap scripts, then calls install.sh
```

## Notes
- [UbutnuでCapsLockキーをCtrlキーする方法](https://linux.just4fun.biz/?Ubuntu/Caps-Lock%E3%82%AD%E3%83%BC%E3%82%92Ctrl%E3%82%AD%E3%83%BC%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)
- [お前らのSSH Keysの作り方は間違っている](https://qiita.com/suthio/items/2760e4cff0e185fe2db9)
- [How to Install Cuda on Ubuntu 24.04](https://www.liberiangeek.net/2024/04/install-cuda-on-ubuntu-24-04/)
- [Ubuntu 24.04@WSL2にCUDAをインストールする（libtinfo5が見つからない問題）](https://qiita.com/gengen16k/items/88cf3c18a40a94205fab)
- [MacのTerminalでsudo実行時にタッチIDを使用する方法](https://dev.classmethod.jp/articles/mac-terminal-sudo-touch-id/)
- [【Ubuntu】内蔵HDDを/etc/fstabを使って自動マウント](https://heppoko-room.net/archives/1878)

## SSHFS for MacOS

1. Install MacFUSE and SSHFS from [https://osxfuse.github.io](https://osxfuse.github.io).

2. To run SSHFS on macOS, you must enable the system extension signed by Benjamin Fleischer (see this [reference](https://applech2.com/archives/20230314-mounty-for-ntfs-v2-support-macos-13-ventura.html)).

3. Enabling the extension requires lowering the security level in Recovery Mode (see [this guide](https://iboysoft.com/howto/enable-system-extension-m1-mac.html)).
