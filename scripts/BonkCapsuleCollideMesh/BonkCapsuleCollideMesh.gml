// Feather disable all

/// @param capsule
/// @param mesh
/// @param [struct]

function BonkCapsuleCollideMesh(_capsule, _mesh, _struct = undefined)
{
    return _mesh.Collide(_capsule, undefined, _struct).__Reverse(_mesh);
}