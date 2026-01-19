// Feather disable all

/// Returns whether a Bonk capsule and world overlap.
///
/// @param capsule
/// @param world

function BonkCapsuleTouchWorld(_capsule, _world)
{
    return _world.Touch(_capsule);
}