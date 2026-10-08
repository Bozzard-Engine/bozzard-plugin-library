// Kennel `steam` package: player rules for the `steam_multiplayer` component.
// Catalog ID `steam/player`; select it as the component's `player_script` and attach it
// (enabled) to every object that carries a `network_player` binding.
//
// Hook contract. The scene loader checks each hook's argument count.
//   network_input(key)                   -> bool  is `key` this game's action key?
//   network_spawn(slot)                  -> map   starting state for protocol slot 0..3
//   network_predict(player, pressed, dt) -> map   one fixed 60 Hz step of one player
// The host and client-side prediction/replay both call these with fresh scopes and f32
// arithmetic, so keep them pure: they cannot issue scene commands. `on_update` only
// presents the replicated, predicted state on the bound object.
//
// Adapted from Flap Woods Together (examples/demo/scenes/flap-woods-multiplayer.json).

fn network_input(key) { key == "Space" }

fn network_spawn(slot) {
    #{ slot: slot, x: -5.0 + slot.to_float() * 0.6, y: 0.65,
       velocity: 0.0, alive: true, score: 0, input_ack: 0 }
}

fn network_predict(player, pressed, dt) {
    if !player.alive { return player; }
    if pressed { player.velocity = 6.5; }
    player.velocity -= 22.0 * dt;
    player.y += player.velocity * dt;
    player
}

fn on_update(me, dt) {
    if !network_active() { return; }
    let player = network_object(me);
    if player.len() == 0 {
        set_position(me, [0.0, 100.0, 0.0]);
        return;
    }
    set_position(me, [player.x, player.y, player.slot.to_float() * 0.05]);
    set_rotation(me, [0.0, 0.0, player.velocity * 4.0]);
    let size = if player.alive { 0.8 } else { 0.45 };
    set_scale(me, [size, size, size]);
}
