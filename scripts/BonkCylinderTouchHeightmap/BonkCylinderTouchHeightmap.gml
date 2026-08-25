// Feather disable all

/// Returns whether a Bonk cylinder and heightmap overlap. This is a approximate, checking the
/// z-position of the heightmap versus the z-position of the bottom of the centre of the shape.
/// For a more accurate check, convert your heightmap into a vertex buffer and add that vertex
/// buffer to a world using `world.AddvertexBuffer()`.
/// 
/// @param cylinder
/// @param heightmap

function BonkCylinderTouchHeightmap(_cylinder, _heightmap)
{
    with(_cylinder)
    {
        return ((z - zSize/2) < _heightmap.GetHeightAt(x, y));
    }
    
    return false;
}