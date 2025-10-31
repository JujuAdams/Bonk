// Feather disable all

/// Returns a line segment determined by a ray shot through a frustrum. The x/y coordinates are in
/// pixels with `0, 0` being the top-left corner. Despite the name, this function can be used with
/// surfaces etc. so long as the "screen" width/height are accurate.
/// 
/// This function returns a struct that contains `x1` `y1` `z1`, the origin of the line segment,
/// and `x2` `y2` `z2`, the ending coordinate of the line segment. These coordinates are in world
/// space.
/// 
/// @param x
/// @param y
/// @param viewMatrix
/// @param projMatrix
/// @param screenWidth
/// @param screenHeight

function UtilScreenToWorld(_x, _y, _viewMatrix, _projMatrix, _screenWidth, _screenHeight)
{
    return UtilFrustrumToWorld(2*(_x / _screenWidth ) - 1, 2*(_y / _screenHeight) - 1, _viewMatrix, _projMatrix);
}