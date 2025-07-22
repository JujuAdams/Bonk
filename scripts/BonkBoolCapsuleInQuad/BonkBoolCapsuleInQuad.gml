// Feather disable all

/// @param capsule
/// @param quad

function BonkBoolCapsuleInQuad(_capsule, _quad)
{
    return;
    
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX  = x;
        var _capsuleY  = y;
        var _capsuleZ1 = z - height + radius;
        var _capsuleZ2 = z + height - radius;
    }
    
    with(_quad)
    {
        var _planeX1 = x1;
        var _planeY1 = y1;
        var _planeZ1 = z1;
        
        var _planeX2 = x2;
        var _planeY2 = y2;
        var _planeZ2 = z2;
        
        var _planeX3 = x3;
        var _planeY3 = y3;
        var _planeZ3 = z3;
        
        var _dX12 = _planeX2 - _planeX1;
        var _dY12 = _planeY2 - _planeY1;
        var _dZ12 = _planeZ2 - _planeZ1;
        var _dX13 = _planeX3 - _planeX1;
        var _dY13 = _planeY3 - _planeY1;
        var _dZ13 = _planeZ3 - _planeZ1;
        
        var _normalX = -(_dZ12*_dY13 - _dY12*_dZ13);
        var _normalY = -(_dX12*_dZ13 - _dZ12*_dX13);
        var _normalZ = -(_dY12*_dX13 - _dX12*_dY13);
        
        var _length = sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
        if (_length <= 0)
        {
            return false;
        }
        
        _normalX /= _length
        _normalY /= _length;
        _normalZ /= _length;
        
        var _planeX4 = _planeX2 + _dX13;
        var _planeY4 = _planeY2 + _dY13;
        var _planeZ4 = _planeZ2 + _dZ13;
        
        UggArrow(_planeX4, _planeY4, _planeZ4,   _planeX4 + 20*_normalX, _planeY4 + 20*_normalY, _planeZ4 + 20*_normalZ,   undefined, undefined, undefined, true);
    }
    
    if ((_normalX == 0) && (_normalY == 0) && (abs(_normalZ) == 1))
    {
        //Capsule is parallel with the plane
    }
    else
    {
        var _dotA = dot_product_3d(_planeX1 - _capsuleX, _planeY1 - _capsuleY, _planeZ1 - _capsuleZ1, _normalX, _normalY, _normalZ);
        var _dotB = dot_product_3d(0, 0, _capsuleZ2 - _capsuleZ1, _normalX, _normalY, _normalZ);
        
        var _u = _dotA / _dotB;
        
        UggCircle(_capsuleX, _capsuleY, lerp(_capsuleZ1, _capsuleZ2, _u), 2*_capsuleRadius, _normalX, _normalY, _normalZ, undefined, true);
        UggCross(_capsuleX, _capsuleY, lerp(_capsuleZ1, _capsuleZ2, _u), 3, undefined, undefined, true);
        
        if ((_u < 0) || (_u > 1))
        {
            return false;
        }
        
        
        
        
        
        
        //var _vX  = _capsuleX  - _planeX1;
        //var _vY  = _capsuleY  - _planeY1;
        //var _vZ1 = _capsuleZ1 - _planeZ1;
        //var _vZ2 = _capsuleZ1 - _planeZ1;
        //
        //var _dot1 = dot_product_3d(_vX, _vY, _vZ1, _normalX, _normalY, _normalZ);
        //var _dot2 = dot_product_3d(_vX, _vY, _vZ2, _normalX, _normalY, _normalZ);
        //
        //if (sign(_dot1) != sign(_dot2))
        //{
        //    //Capsule intersects the plane
        //}
        //else
        //{
        //    if ((abs(_dot1) > _capsuleRadius) && (abs(_dot2) > _capsuleRadius))
        //    {
        //        //Both ends of the capsule are too far away from the plane for the primitives to intersect
        //        return false;
        //    }
        //    
        //    if (abs(_dot1) < abs(_dot2))
        //    {
        //        var _pX = _capsuleX  - _dot1*_normalX;
        //        var _pY = _capsuleY  - _dot1*_normalY;
        //        var _pZ = _capsuleZ1 - _dot1*_normalZ;
        //    }
        //    else
        //    {
        //        var _pX = _capsuleX  - _dot2*_normalX;
        //        var _pY = _capsuleY  - _dot2*_normalY;
        //        var _pZ = _capsuleZ1 - _dot2*_normalZ;
        //    }
        //}
    }
}