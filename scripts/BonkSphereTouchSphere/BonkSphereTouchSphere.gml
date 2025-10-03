// Feather disable all

/// Returns whether two Bonk spheres overlap.
/// 
/// @param sphereA
/// @param sphereB

function BonkSphereTouchSphere(_sphereA, _sphereB)
{
    with(_sphereA)
    {
        return (point_distance_3d(x, y, z, _sphereB.x, _sphereB.y, _sphereB.z) < _sphereA.radius + _sphereB.radius);
    }
    
    return false;
}