// Feather disable all

/// @param line
/// @param floor

function BonkLineInFloor(_line, _floor)
{
    with(_line)
    {
        if (z1 == z2) return false;
        if (min(z1, z2) > _floor.z) return false;
        if (max(z1, z2) < _floor.z) return false;
        
        var _t = (_floor.z - z1) / (z2 - z1);
        var _x = x1 + _t*(x2 - x1);
        var _y = y1 + _t*(y2 - y1);
        
        return (point_in_rectangle(_x, _y, _floor.x1, _floor.y1, _floor.x2, _floor.y2) > 0);
    }
}