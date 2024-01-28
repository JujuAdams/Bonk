// Feather disable all

/// @param cylinder
/// @param floor

function BonkCylinderInFloor(_cylinder, _floor)
{
    static _reaction = new __BonkClassReaction();
    
    with(_cylinder)
    {
        if ((z - 0.5*height >= _floor.z) || (z + 0.5*height <= _floor.z))
        {
            _reaction.__NoCollision();
            return _reaction;
        }
        
        if (rectangle_in_circle(_floor.x1, _floor.y1, _floor.x2, _floor.y2, x, y, radius))
        {
            with(_reaction)
            {
                collision = true;
                dX = 0;
                dY = 0;
                dZ = (_floor.z + 0.5*_cylinder.height) - _cylinder.z;
            }
        }
        else
        {
            _reaction.__NoCollision();
        }
        
        return _reaction;
    }
}