// Feather disable all

/// @param aabb
/// @param cylinder

function BonkAABBInCylinder(_aabb, _cylinder)
{
    static _reaction = new __BonkClassReaction();
    
    with(_cylinder)
    {
        var _minZ = z - 0.5*height;
        var _maxZ = z + 0.5*height;
    }
    
    with(_aabb)
    {
        if ((z - zHalfSize >= _maxZ) || (z + zHalfSize <= _minZ))
        {
            _reaction.__NoCollision();
            return _reaction;
        }
        
        if (rectangle_in_circle(x - xHalfSize, y - yHalfSize,
                                x + xHalfSize, y + yHalfSize,
                                _cylinder.x, _cylinder.y, _cylinder.radius))
        {
            with(_reaction)
            {
                collision = true;
                dX = 0;
                dY = 0;
                dZ = (_minZ - _aabb.zHalfSize) - _aabb.z;
            }
        }
        else
        {
            _reaction.__NoCollision();
        }
        
        return _reaction;
    }
}