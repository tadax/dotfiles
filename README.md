# dotfiles

## Notes
- [UbutnuでCapsLockキーをCtrlキーする方法](https://linux.just4fun.biz/?Ubuntu/Caps-Lock%E3%82%AD%E3%83%BC%E3%82%92Ctrl%E3%82%AD%E3%83%BC%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)
- [お前らのSSH Keysの作り方は間違っている](https://qiita.com/suthio/items/2760e4cff0e185fe2db9)
- [How to Install Cuda on Ubuntu 24.04](https://www.liberiangeek.net/2024/04/install-cuda-on-ubuntu-24-04/)
- [Ubuntu 24.04@WSL2にCUDAをインストールする（libtinfo5が見つからない問題）](https://qiita.com/gengen16k/items/88cf3c18a40a94205fab)
- [MacのTerminalでsudo実行時にタッチIDを使用する方法](https://dev.classmethod.jp/articles/mac-terminal-sudo-touch-id/)
- [【Ubuntu】内蔵HDDを/etc/fstabを使って自動マウント](https://heppoko-room.net/archives/1878)

## Ubuntu

### Adjust brightness on Apple Studio Display

1. Install nvidia-driver

Install `nvidia-driver-535`
```
$ ./.cuda121-ubuntu2404
```

2. Install `brighness-controller`

```
$ sudo apt install brightness-controller
```

cf. https://www.geeksforgeeks.org/how-to-control-screen-brightness-in-ubuntu-22-04/



## MacOS

### SSHFS
https://osxfuse.github.io から MacFUSE と SSHFS をインストールする。
ただし実行するには Benjamin Fleischer 氏の署名した機能拡張を有効にする必要がある (cf. https://applech2.com/archives/20230314-mounty-for-ntfs-v2-support-macos-13-ventura.html )。
機能拡張を有効にするには Recovery mode でセキュリティレベルを下げる必要がある (cf. https://iboysoft.com/howto/enable-system-extension-m1-mac.html )。


### `bootstrap/` vs `scripts/`

#### Purpose & Timing

- `bootstrap/`: Initial setup scripts for a fresh machine.
Used once when provisioning a new environment. Often OS-specific and package-manager-specific.
Example: `bootstrap/apt.sh` (Debian/Ubuntu), `bootstrap/brew.sh` (macOS), `bootstrap/install_fonts.sh`.

Goal: Install all system-level dependencies required for your dotfiles to work.

`scripts/`: Utility and setup scripts you might run multiple times.
Typically OS-agnostic or with minimal OS dependencies.
Example: `scripts/setup_vim.sh` (install Vundle & Vim plugins), `scripts/setup_pyenv.sh` (install pyenv & Python), `scripts/update_all.sh`.

Goal: Configure tools, install plugins, or update your environment after the base system is ready.


#### Rule of Thumb

- Does it depend heavily on the OS or package manager? -> Put it in `bootstrap/`.
- Is it part of base environment provisioning? -> `bootstrap/`.
- Can it be run multiple times after the environment exists? -> `scripts/`.
- Is it about configuring or updating tools? -> `scripts/`.


#### Workflow Example

1. Run a `bootstrap/` script to install system dependencies.

Example:

```bash
./bootstrap/apt.sh --upgrade
```

2. Run a `scripts/` script to configure tools.

Example:

```bash
./scripts/setup_pyenv.sh
./scripts/setup_vim.sh
```
