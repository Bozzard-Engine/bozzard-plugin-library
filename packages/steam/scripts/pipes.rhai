// Kennel `steam` package: obstacle presentation for the `steam_multiplayer` component.
// Catalog ID `steam/pipes`; attach it to each object with a `network_obstacle` binding
// (index 0..2). The host's round rules own movement and recycling; this script only places
// the obstacle and its `<id>-bottom` / `<id>-top` children from the replicated state.
//
// Adapted from Flap Woods Together (examples/demo/scenes/flap-woods-multiplayer.json).

fn on_update(me, dt) {
    if !network_active() { return; }
    let pipe = network_object(me);
    if pipe.len() == 0 { return; }
    set_position(me, [pipe.x, 0.0, 0.0]);
    set_position(me + "-bottom", [0.0, pipe.gap - 9.05, 0.0]);
    set_position(me + "-top", [0.0, pipe.gap + 9.05, 0.0]);
}
