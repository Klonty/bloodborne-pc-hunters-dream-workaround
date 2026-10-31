# bloodborne-pc-hunters-dream-workaround

> **Superseded by the full fork:** [Klonty/bloodborne-pc-hunters-dream](https://github.com/Klonty/bloodborne-pc-hunters-dream)
> restores The Hunter's Dream in the launcher source and ships a ready launcher patch. This
> repository stays as a minimal `BB_HUNTERS_DREAM=1` workaround for the official 1.9.7 build.

A small, unofficial workaround that brings back **The Hunter's Dream** co-op pool in
**bbport 1.9.7** — the Windows port of Bloodborne by Supermedo.

The 1.9.7 launcher hides The Hunter's Dream and silently moves every player to
`SuperMedo Server`. The support for The Hunter's Dream is still in the launcher and in the
game, but it is gated behind one environment variable:

```text
BB_HUNTERS_DREAM=1
```

These scripts set that variable before the launcher or the game starts. No files are
patched, no binaries are replaced, and no game data is included.

## What is in this repository

- `windows/` — `.bat` launchers for Windows.
- `linux/` — shell launchers for Wine / Proton.
- `docs/how-it-works.md` — what the variable does and why editing
  `user/host_overrides.json` by hand does not stick.
- No `Bloodborne.exe`, no `eboot.bin`, no game assets, no proprietary DLLs.

## Requirements

- bbport **1.9.7** for Windows (`Bloodborne.exe`, `Play Bloodborne.exe`).
- Your own legal copy of Bloodborne and a decrypted dump (the port does not include the game).
- A The Hunter's Dream account. Sign-in is done through their website with Discord.
- Windows 10/11, or Linux with Wine/Proton for the shell scripts.

## Usage on Windows

1. Copy both files from `windows/` into the folder that contains `Bloodborne.exe`.
2. Run `hunters-dream-launcher.bat`.
3. On the **Online play** page:
   - tick **Play online**;
   - choose **The Hunter's Dream (previous server)** under **Co-op pool**;
   - press **Sign in with Discord** and approve the code on The Hunter's Dream website;
   - press **Test connection**, then **PLAY**.
4. After the first sign-in you can use `hunters-dream-play.bat` to start the game directly.

The scripts use `%~dp0`, so they work from any folder and with a copied shortcut.

## Usage on Linux / Wine

From the repository root:

```bash
./linux/hunters-dream-launcher.sh "/path/to/Bloodborne.exe"
./linux/hunters-dream-play.sh "/path/to/Play Bloodborne.exe"
```

Or point `BBPORT_DIR` at the port folder:

```bash
BBPORT_DIR="/path/to/Bloodborne-Windows" ./linux/hunters-dream-launcher.sh
```

`wine` must be in `PATH`. On Steam Deck / Proton, use the Windows `.bat` through your
usual non-Steam shortcut, or add the variable to the launch options:

```text
BB_HUNTERS_DREAM=1 %command%
```

On Windows, Steam launch options do not support `VAR=value` syntax. Add the `.bat` as a
non-Steam game, or set the variable permanently (below).

## Permanent setup

Windows (new terminals and launcher processes only):

```bat
setx BB_HUNTERS_DREAM 1
```

Undo it with:

```bat
reg delete HKCU\Environment /v BB_HUNTERS_DREAM /f
```

Linux (add to `~/.profile` or `~/.bashrc`):

```bash
export BB_HUNTERS_DREAM=1
```

With the variable set globally, the normal `Bloodborne.exe` and `Play Bloodborne.exe`
shortcuts keep The Hunter's Dream enabled.

## How it works

The launcher computes the pool flag once at start-up:

```python
HUNTERS_DREAM_POOL = os.environ.get('BB_HUNTERS_DREAM', '0') == '1'
```

Without the variable, the launcher does not create the The Hunter's Dream radio button and
`settled_pool()` / `chosen_pool()` / `game_server()` fall back to `SuperMedo Server`. With
the variable set, the option is available and the game is started with
`BB_NET_BACKEND=thd`, `BB_THD_ONLINE_ID` and `BB_THD_TOKEN`.

See [`docs/how-it-works.md`](docs/how-it-works.md) for the exact code paths, the host
overrides, and the version caveat.

## Troubleshooting

**The Hunter's Dream option is still missing**

- The variable was not set in the process that started the launcher. Close every launcher
  window and start it through `hunters-dream-launcher.bat`.
- You are not on 1.9.7. Newer builds may remove the gate entirely; the workaround is
  version-specific.
- Another launcher instance was already running and received the old environment.

**The game still connects to SuperMedo**

- The pool is saved per launcher profile. Select The Hunter's Dream again on the Online
  page and press PLAY from that window.
- Check that the variable is visible in the same terminal:
  `echo %BB_HUNTERS_DREAM%` (Windows) or `echo $BB_HUNTERS_DREAM` (Linux).

**Sign-in fails**

- The Hunter's Dream sign-in and server are run by a third party. This project does not
  host or proxy anything.
- The original port asks players not to contact The Hunter's Dream support about bbport
  itself. Report port problems in the bbport community instead.

## Disclaimer

This is an unofficial community workaround. It is not affiliated with, endorsed by, or
supported by Supermedo, the bbport contributors, The Hunter's Dream, Sony Interactive
Entertainment, or FromSoftware.

- No game files, binaries, keys, saves, tokens, or server software are distributed here.
- You must own Bloodborne and use your own dump.
- The Hunter's Dream and SuperMedo Server are third-party services with their own rules.
  You are responsible for following them.
- "Bloodborne" is a trademark of Sony Interactive Entertainment. The name is used only to
  describe what this workaround is for.

## License

The scripts and documentation in this repository are released under the MIT License; see
[`LICENSE`](LICENSE).

The original bbport project is licensed under GPL-2.0-or-later, with GPL-3.0-or-later
online-code parts; this repository contains none of its source code or binaries.
