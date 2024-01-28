// Feather disable all

/// @param sphereA
/// @param sphereB

function BonkSphereInSphere(_sphereA, _sphereB)
{
    with(_sphereA)
    {
        return (point_distance_3d(x, y, z, _sphereB.x, _sphereB.y, _sphereB.z) < _sphereA.radius + _sphereB.radius);
    }
    
    return false;
}