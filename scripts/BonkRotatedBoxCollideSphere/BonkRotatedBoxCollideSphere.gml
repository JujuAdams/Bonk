// Feather disable all

/// @param box
/// @param sphere

function BonkRotatedBoxCollideSphere(_box, _sphere)
{
    return BonkSphereCollideRotatedBox(_sphere, _box).__Reverse();
}