// Feather disable all

/// @param box
/// @param sphere
/// @param [struct]

function BonkRotatedBoxCollideSphere(_box, _sphere, _struct = undefined)
{
    return BonkSphereCollideRotatedBox(_sphere, _box, _struct).__Reverse(_sphere);
}