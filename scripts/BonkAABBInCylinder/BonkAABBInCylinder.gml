// Feather disable all

/// @param aabb
/// @param cylinder

function BonkAABBInCylinder(_aabb, _cylinder)
{
    static _reaction = new __BonkClassReaction();
    
    with(_cylinder)
    {
        var _cylinderX = x;
        var _cylinderY = y;
        var _cylinderR = radius;
        
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
        
        var _left   = x - xHalfSize;
        var _top    = y - yHalfSize;
        var _below  = z - zHalfSize;
        var _right  = x + xHalfSize;
        var _bottom = y + yHalfSize;
        var _above  = z + zHalfSize;
        
        if (rectangle_in_circle(_left, _top, _right, _bottom, _cylinder.x, _cylinder.y, _cylinder.radius))
        {
            var _pushX = 0;
            var _pushY = 0;
            var _pushZ = 0;
            
            if (point_in_rectangle(_cylinder.x, _cylinder.y, _left, _top, _right, _bottom))
            {
                //Centre of cylinder is inside the AABB
                var _lPush = (_cylinderX + _cylinderR) - _left;
                var _tPush = (_cylinderY + _cylinderR) - _top;
                var _rPush = _right  - (_cylinderX - _cylinderR);
                var _bPush = _bottom - (_cylinderY - _cylinderR);
                
                
                var _pushDistance = min(_lPush, _tPush, _rPush, _bPush);
                if (_lPush == _pushDistance) _pushX =  _lPush;
                if (_tPush == _pushDistance) _pushY =  _tPush;
                if (_rPush == _pushDistance) _pushX = -_rPush;
                if (_bPush == _pushDistance) _pushY = -_bPush;
            }
            else
            {
                var _x = clamp(_cylinderX, _left, _right);
                var _y = clamp(_cylinderY, _top, _bottom);
                
                var _dX = _x - _cylinderX;
                var _dY = _y - _cylinderY;
                var _d  = sqrt(_dX*_dX + _dY*_dY);
                
                var _pushX = _cylinderR*(_dX / _d) - _dX;
                var _pushY = _cylinderR*(_dY / _d) - _dY;
                
                _pushDistance = _cylinderR - _d;
            }
            
            var _pushBelow = _maxZ - _below; 
            var _pushAbove = _above - _minZ; 
            
            if (_pushBelow < _pushDistance)
            {
                _pushX = 0;
                _pushY = 0;
                _pushZ = _pushBelow;
                
                _pushDistance = _pushBelow;
            }
            
            if (_pushAbove < _pushDistance)
            {
                _pushX = 0;
                _pushY = 0;
                _pushZ = -_pushAbove;
            }
            
            with(_reaction)
            {
                collision = true;
                dX = _pushX;
                dY = _pushY;
                dZ = _pushZ;
            }
        }
        else
        {
            _reaction.__NoCollision();
        }
        
        return _reaction;
    }
}