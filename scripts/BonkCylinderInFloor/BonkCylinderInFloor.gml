// Feather disable all

/// @param cylinder
/// @param floor

function BonkCylinderInFloor(_cylinder, _floor)
{
    with(_cylinder)
    {
        if ((z - 0.5*height > _floor.z) || (z + 0.5*height <= _floor.z)) return false;
        
        return (rectangle_in_circle(_floor.x1, _floor.y1, _floor.x2, _floor.y2, x, y, radius) > 0);
    }
    
    return false;
}