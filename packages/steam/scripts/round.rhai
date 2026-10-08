// Kennel `steam` package: host-only round rules for the `steam_multiplayer` component.
// Catalog ID `steam/round`; select it as the component's `world_script`. Attach it to a
// HUD text object to show the scoreboard.
//
// Hook contract. The scene loader checks each hook's argument count.
//   network_countdown()                     -> int   ticks (60 Hz) before a round starts
//   network_pipes()                         -> array starting state of the 3 obstacles
//   network_step(pipes, dt)                 -> array one fixed step of the obstacles
//   network_resolve(player, before, after)  -> map   collisions and scoring for one player
//   network_finished(players)               -> bool  has the round ended?
// Only the host runs these; clients receive the results. Prediction never calls scoring or
// collision hooks. State is explicit, so every round starts from these values.
//
// Adapted from Flap Woods Together (examples/demo/scenes/flap-woods-multiplayer.json).

fn network_countdown() { 300 }

fn network_pipes() {
    [#{x: 2.0, gap: 0.0, cycle: 0},
     #{x: 11.0, gap: 1.9, cycle: 0},
     #{x: 20.0, gap: -1.9, cycle: 0}]
}

fn network_step(pipes, dt) {
    for i in 0..pipes.len() {
        pipes[i].x -= 3.2 * dt;
        if pipes[i].x < -13.0 {
            pipes[i].x += 27.0;
            pipes[i].cycle += 1;
            pipes[i].gap = (((pipes[i].cycle + i) % 5).to_float() - 2.0) * 0.85;
        }
    }
    pipes
}

fn network_resolve(player, before, after) {
    if !player.alive { return player; }
    if abs(player.y) > 4.65 { player.alive = false; }
    for pipe in after {
        if abs(pipe.x - player.x) < 1.0 && abs(player.y - pipe.gap) > 2.15 {
            player.alive = false;
        }
    }
    if player.alive {
        for i in 0..after.len() {
            if before[i].x + 0.6 >= player.x - 0.4 && after[i].x + 0.6 < player.x - 0.4 {
                player.score += 1;
            }
        }
    }
    player
}

fn network_finished(players) {
    for player in players { if player.alive { return false; } }
    true
}

// The scoreboard: the object's normal Script Manager hook owns its text.
fn on_update(me, dt) {
    if !network_active() { return; }
    let scores = "";
    for player in network_state().players {
        if scores != "" { scores += "   "; }
        scores += "P" + (player.slot + 1);
        if player.local { scores += " YOU"; }
        scores += ": " + player.score;
        if !player.alive { scores += " OUT"; }
    }
    set_text(me, if scores == "" { "STEAM LOBBY" } else { scores });
}
