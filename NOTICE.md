# Notices

This repository contains only small launcher scripts and documentation. It does not
contain, host, or redistribute any of the following:

- Bloodborne game files, decrypted dumps, `eboot.bin`, or `dvdroot_ps4` content;
- `Bloodborne.exe`, `bin/bb-probe.exe`, DLLs, FSR/DLSS runtimes, or any other binary from
  the bbport distribution;
- saves, shader caches, play logs, Discord tokens, passwords, or launcher settings;
- The Hunter's Dream server software, its backend, or its account database.

## Third-party projects and services

- **bbport / Bloodborne for Windows** — the port this workaround targets. Its own code is
  GPL-2.0-or-later, and the combined distribution is GPL-3.0-or-later because of the
  online code from bbhost and the FSR 4.1 launcher files. This repository does not copy
  that code; it only sets a documented environment variable.
- **The Hunter's Dream** — a third-party co-op service. This project does not host,
  operate, or proxy it. Use of the service is governed by its own rules.
- **SuperMedo Server** — a third-party service operated by the port author. This project
  does not host or modify it.
- **shadPS4 / shadNet** — third-party emulator and network projects with their own
  licenses and terms.

## Trademarks

"Bloodborne" and related names are trademarks of Sony Interactive Entertainment and
FromSoftware. "The Hunter's Dream" refers to the in-game location and to the community
service of the same name. This project is unofficial and is not endorsed by any of the
rights holders or service operators.

## No warranty

The scripts are provided under the MIT License, without warranty of any kind. Setting
`BB_HUNTERS_DREAM=1` changes which third-party server the game contacts. You are
responsible for your own account, network traffic, and compliance with the applicable
service rules.
