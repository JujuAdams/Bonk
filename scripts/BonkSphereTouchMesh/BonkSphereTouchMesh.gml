// Feather disable all

/// Returns whether a Bonk sphere and mesh overlap.
/// 
/// @param sphere
/// @param mesh

function BonkSphereTouchMesh(_sphere, _mesh)
{
    return _mesh.Touch(_sphere);
}