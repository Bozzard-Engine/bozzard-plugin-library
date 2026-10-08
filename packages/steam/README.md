# Steam

Steamworks for Bozzard games: the Steam API redistributables in the SDK's folder layout,
plus starter rules scripts for the engine's `steam_multiplayer` component.

| | |
| --- | --- |
| Package | `steam` 1.0.0 |
| Category | integration |
| Engine | Bozzard ≥ 0.1.0, script API 1, built with the `steam` Cargo feature (the editor and player default) |
| Binaries | `linux-x86_64`, `linux-aarch64`, `macos-x86_64`, `macos-aarch64`, `windows-x86_64` |
| Upstream | `steamworks-sys` 0.13.0 on crates.io: the same SDK the engine compiles against |

## Install

```sh
bozzard-project kennel install steam path/to/my-game
```

Kennel installs into `my-game/kennel/steam/`, records the package in `my-game/kennel.lock.json`,
and prints the build variable to set:

```text
kennel_install_ok name=steam version=1.0.0 dir=/…/my-game/kennel/steam files=6 targets=linux-x86_64 requires_features=steam
STEAM_SDK_LOCATION=/…/my-game/kennel/steam/sdk
```

The binaries aren't stored in the registry. Kennel downloads Valve's files from the pinned
`steamworks-sys` 0.13.0 crate, checks the crate's SHA-256, extracts only the named library,
and checks that library's size and SHA-256 too. Pass `--all-targets` to install the libraries
for every platform rather than just this machine's.

## Build against the installed SDK

`sdk/` mirrors the Steamworks SDK's `redistributable_bin/` layout, so it works as
`STEAM_SDK_LOCATION` for both Bozzard's `tools/steam_build.rs` and `steamworks-sys`. The
variable must be an absolute path.

```sh
STEAM_SDK_LOCATION=/abs/path/my-game/kennel/steam/sdk \
  cargo build --release -p bozzard-editor-app -p bozzard-player
target/release/bozzard-player --runtime-info   # steam_library.sha256 matches the manifest
```

Standard builds already find this same SDK in Cargo's registry cache. Set the variable for
vendored or offline builds, or when you want the build to use exactly the files Kennel verified.
Windows builds need `steam_api64.lib` as well as the DLL, so the Windows target installs both.

## Use the scripts in a scene

Add the scripts to the scene's asset catalog. Paths are relative to the scene file; for a
scene in `my-game/scenes/`:

```json
"assets": {
  "steam/player": { "kind": "script", "path": "../kennel/steam/scripts/player.rhai" },
  "steam/round":  { "kind": "script", "path": "../kennel/steam/scripts/round.rhai" },
  "steam/pipes":  { "kind": "script", "path": "../kennel/steam/scripts/pipes.rhai" }
}
```

Then configure the multiplayer component on one object:

```json
"steam_multiplayer": {
  "game": "my_game",
  "protocol": 3,
  "app_id": 480,
  "max_players": 4,
  "player_script": "steam/player",
  "world_script": "steam/round"
}
```

Bind up to four player objects with **Network Player** (`slot` 0–3), each with `steam/player`
enabled in its Script Manager. Bind the three obstacles with **Network Obstacle** (`index` 0–2),
each with `steam/pipes`. Put `steam/round` on a text object to show the scoreboard.
`examples/demo/scenes/flap-woods-multiplayer.json` in the engine repository is a complete scene
built this way. The inspector can't add Steam Multiplayer to an object, so author it in the
scene JSON as the example does.

The scripts are the Flap Woods Together rules, with comments describing each hook's contract.
Change the numbers and the presentation as you like. The hook set itself is fixed by the
engine: 2–4 players and three obstacles, replicated by the host. It isn't general-purpose
scene replication, and Rhai can't access the Steam account.

## App IDs

- **480 (Spacewar)** is Valve's development app. Exports with 480 include `steam_appid.txt`
  and open directly while Steam is running.
- **Your own App ID** produces a store build without `steam_appid.txt`. It starts from Steam's
  launch context, so configure it in your Steam launch options. Valve requires removing the
  development App ID file before you upload a depot.

See the engine's `docs/multiplayer.md` for lobbies, invitations, the overlay and export
details.

## License

The scripts, this README and the manifest are MIT OR Apache-2.0. The Steam API libraries are
Valve's; see [NOTICE.md](NOTICE.md).
