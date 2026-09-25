// Feather disable all

/// @param sphere
/// @param mesh
/// @param [struct]

function BonkSphereCollideMesh(_sphere, _mesh, _struct = undefined)
{
    return _mesh.Collide(_sphere, -1, _struct).__Reverse(_mesh);
}