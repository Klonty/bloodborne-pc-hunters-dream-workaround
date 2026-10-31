# How it works

This page describes the 1.9.7 behaviour of the Windows launcher (`Bloodborne.exe`, a
PyInstaller build) and why setting one environment variable is enough to restore The
Hunter's Dream. All observations below were made on the 1.9.7 launcher and its bundled
`run.py` / `bin/bb-probe.exe`.

## The gate

At import time the launcher evaluates:

```python
HUNTERS_DREAM_POOL = os.environ.get('BB_HUNTERS_DREAM', '0') == '1'
```

The rest of the launcher treats that constant as "is The Hunter's Dream offered at all".
It is the only switch; there is no server-side check and no separate settings.json key.

## What happens without the variable

The launcher still has all the The Hunter's Dream code, but the normal path never reaches
it:

- `build_online()` does not create the The Hunter's Dream radio button. Only
  `SuperMedo Server` is offered (and `Own server` for Seamless co-op starts).
- `show_pool()` rewrites a saved `online_pool == 'huntersdream'` to `'supermedo'`.
- `settled_pool()` returns `'supermedo'` for any saved pool other than `huntersdream`.
- `chosen_pool()` returns `'supermedo'` when the saved pool is `huntersdream` and the gate
  is off.
- `game_server()` returns `COMMUNITY_SERVER` (`https://game.supermedo.com`) instead of
  `HUNTERS_DREAM_SERVER`.

In other words, the option is hidden and old settings are migrated to SuperMedo Server on
every start.

## What happens with `BB_HUNTERS_DREAM=1`

- `build_online()` creates the extra radio button
  `The Hunter's Dream (previous server)`.
- `settled_pool()` keeps `huntersdream` instead of rewriting it.
- `chosen_pool()` returns `'huntersdream'`.
- `game_server()` returns `https://thehuntersdream.com`.
- `game_environment()` starts the game with:
  - `BB_ONLINE=1`
  - `BB_NET_BACKEND=thd`
  - `BB_THD_ONLINE_ID` and `BB_THD_TOKEN` from the launcher's Discord sign-in
  - `BB_BRIDGE_LIVE_MAP=1` if the live-map option is on
  - and removes the `BB_SHADNET_*` variables so the shadNet client is not used for this pool.

The The Hunter's Dream sign-in itself is a device-code flow against
`https://thehuntersdream.com/auth/device/start` and `/auth/device/poll`. It is separate
from SuperMedo's Discord login. Nothing in this workaround creates an account or bypasses
authentication.

## What `run.py` does next

When the game is launched with `BB_ONLINE=1` and `BB_NET_BACKEND=thd`, `run.py` calls
`hunters_dream()`:

- writes `user/host_overrides.json` with `*.scej-network.jp` pointing at
  `https://thehuntersdream.com` and the play-log hosts pointing at
  `https://thehuntersdream.com:18671`;
- sets `BB_THD_SERVER`, `BB_THD_AUTH`, `BB_THD_RULESET`, `BB_P2P_PORT` and
  `BB_SIGN_TIMEOUT`;
- removes `BB_SHADNET_SERVER`, `BB_SHADNET_WEBAPI`, `BB_SHADNET_NPID`,
  `BB_SHADNET_PASSWORD` and `BB_SHADNET_TOKEN` from the child environment.

The native side in `bin/bb-probe.exe` contains the The Hunter's Dream backend
(`BB_THD_SERVER`, `BB_THD_AUTH`, `BB_THD_TOKEN`, `BB_THD_STUN`, `BB_THD_P2P_ADDR`,
`BB_THD_VERIFY_TLS`, and so on), adapted from bbhost.

## Why editing `user/host_overrides.json` by hand does not work

`run.py` rewrites that file at every start:

- for The Hunter's Dream only when `BB_NET_BACKEND=thd`;
- otherwise through `online_overrides()`, which points the game at the configured community
  server (SuperMedo by default).

So a manual edit is overwritten on the next launch. The supported way to select the pool is
the launcher setting plus the environment variable, not the JSON file.

## Version caveat

This workaround is specific to **1.9.7**. It relies on the `BB_HUNTERS_DREAM` gate still
existing in the launcher. A future build may remove the gate, rename the variable, or
remove the The Hunter's Dream backend entirely. If that happens, these scripts will not
restore the pool.

The workaround does not modify the launcher, the game, or any server, so it also does not
guarantee that a future server-side change will accept the client.
