// Feather disable all

/// Returns whether a Bonk capsule and mesh overlap.
///
/// @param capsule
/// @param mesh

function BonkCapsuleTouchMesh(_capsule, _mesh)
{
    return _mesh.Touch(_capsule);
}