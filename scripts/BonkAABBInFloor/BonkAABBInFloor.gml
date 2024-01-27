// Feather disable all

/// @param aabb
/// @param floor

function BonkAABBInFloor(_aabb, _floor)
{
    with(_aabb)
    {
        if ((z - zHalfSize > _floor.z) || (z + zHalfSize <= _floor.z)) return false;
        
        return (rectangle_in_rectangle(x - xHalfSize, y - yHalfSize, x + xHalfSize, y + yHalfSize,
                                       _floor.x1, _floor.y1, _floor.x2, _floor.y2) > 0);
    }
    
    return false;
}