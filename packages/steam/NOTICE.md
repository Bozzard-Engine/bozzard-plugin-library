# Notices

## Package files

`steam.pkg.json`, `README.md`, `NOTICE.md` and `scripts/*.rhai` are licensed under
MIT OR Apache-2.0, at your option. The scripts are adapted from Bozzard's Flap Woods Together
example.

## Steamworks API libraries

`sdk/redistributable_bin/**` (`libsteam_api.so`, `libsteam_api.dylib`, `steam_api64.dll`,
`steam_api64.lib`) are © Valve Corporation, part of the Steamworks SDK. Your use and
redistribution of them, including shipping them with a game, is governed by the
[Steamworks SDK Access Agreement](https://partner.steamgames.com/documentation/sdk_access_agreement).
Review it before you ship.

The Kennel registry doesn't host these files. On install, Kennel downloads them from the
`steamworks-sys` 0.13.0 package on crates.io (the copy the Bozzard engine already builds
against) and checks each file against the SHA-256 in `steam.pkg.json`.

Steam and the Steam logo are trademarks of Valve Corporation. This package is not affiliated
with or endorsed by Valve.
