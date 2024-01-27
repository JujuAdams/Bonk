// Feather disable all

/// @param cylinder1
/// @param cylinder2

function BonkCylinderInCylinder(_cylinder1, _cylinder2)
{
    with(_cylinder1)
    {
        if ((z - 0.5*height >  _cylinder2.z + 0.5*_cylinder2.height)
        ||  (z + 0.5*height <= _cylinder2.z - 0.5*_cylinder2.height)) return false;
        
        return (point_distance(x, y, _cylinder2.x, _cylinder2.y) < radius + _cylinder2.radius);
    }
    
    return false;
}