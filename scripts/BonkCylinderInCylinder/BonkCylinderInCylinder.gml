// Feather disable all

/// @param cylinder1
/// @param cylinder2

function BonkCylinderInCylinder(_cylinder1, _cylinder2)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_cylinder1)
    {
        var _zMin1 = z - 0.5*height;
        var _zMax1 = z + 0.5*height;
        
        var _zMin2 = _cylinder2.z - 0.5*_cylinder2.height;
        var _zMax2 = _cylinder2.z + 0.5*_cylinder2.height;
        
        var _pushDown = _zMax1 - _zMin2;
        var _pushUp   = _zMax2 - _zMin1;
        
        if ((_pushDown >= 0) && (_pushUp <= 0))
        {
            return _nullReaction;
        }
        
        var _dX = x - _cylinder2.x;
        var _dY = y - _cylinder2.y;
        
        var _xyDist = sqrt(_dX*_dX + _dY*_dY);
        var _pushXY = (radius + _cylinder2.radius) - _xyDist;
        
        if (_pushXY <= 0)
        {
            return _nullReaction;
        }
        
        _reaction.collision = true;
        
        var _dZ = (abs(_pushDown) < abs(_pushUp))? _pushDown : _pushUp;
        if (abs(_dZ) < _pushXY)
        {
            _reaction.dX = 0;
            _reaction.dY = 0;
            _reaction.dZ = _dZ;
        }
        else
        {
            var _coeff = _pushXY / _xyDist;
            _reaction.dX = _coeff*_dX;
            _reaction.dY = _coeff*_dY;
            _reaction.dZ = 0;
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}