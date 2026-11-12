// Feather disable all

/// Returns whether a Bonk AAB and heightmap overlap. This is a approximate, checking the
/// z-position of the heightmap versus the z-position of the bottom of the centre of the shape.
/// For a more accurate check, convert your heightmap into a vertex buffer and add that vertex
/// buffer to a world using `world.AddvertexBuffer()`.
/// 
/// @param aab
/// @param heightmap

function BonkAABTouchHeightmap(_aab, _heightmap)
{
    with(_aab)
    {
        return BonkPointTouchHeightmap(_heightmap, x, y, z - zSize/2);
    }
    
    return false;
}