// Feather disable all

/// @param cylinder1
/// @param cylinder2

function BonkCylinderInCylinder(_cylinder1, _cylinder2)
{
    with(_cylinder1)
    {
        if ((z - height >  _cylinder2.z + _cylinder2.height)
        &&  (z + height <= _cylinder2.z - _cylinder2.height)) return false;
        
        return (point_distance(x, y, _cylinder1.x, _cylinder1.y) < radius + _cylinder2.radius);
    }
    
    return false;
}