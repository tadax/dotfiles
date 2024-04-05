# dotfiles

## Notes
- [UbutnuでCapsLockキーをCtrlキーする方法](https://linux.just4fun.biz/?Ubuntu/Caps-Lock%E3%82%AD%E3%83%BC%E3%82%92Ctrl%E3%82%AD%E3%83%BC%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)
- [お前らのSSH Keysの作り方は間違っている](https://qiita.com/suthio/items/2760e4cff0e185fe2db9)
- [ubuntuにCUDA、nvidiaドライバをインストールするメモ](https://qiita.com/porizou1/items/74d8264d6381ee2941bd)
- [Ubuntu18.04 + CUDA + cuDNN + Pytorchの環境構築](https://techblog.nullstack.engineer/entry/cuda-setup/)
- [MacのTerminalでsudo実行時にタッチIDを使用する方法](https://dev.classmethod.jp/articles/mac-terminal-sudo-touch-id/)

## Ubuntu

### GPU

```
$ sh .cuda-118
```

## MacOS

### SSHFS
https://osxfuse.github.io から MacFUSE と SSHFS をインストールする。
ただし実行するには Benjamin Fleischer 氏の署名した機能拡張を有効にする必要がある (cf. https://applech2.com/archives/20230314-mounty-for-ntfs-v2-support-macos-13-ventura.html )。
機能拡張を有効にするには Recovery mode でセキュリティレベルを下げる必要がある (cf. https://iboysoft.com/howto/enable-system-extension-m1-mac.html )。

実行例
```
$ mkdir -p /Users/tadax/mnt/home
$ sshfs gpu:/home/tadax /Users/tadax/mnt/home
$ mkdir -p /Users/tadax/mnt/dev
$ sshfs gpu:/mnt/dev /Users/tadax/mnt/dev
```
