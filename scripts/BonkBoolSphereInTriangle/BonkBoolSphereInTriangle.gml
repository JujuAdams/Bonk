// Feather disable all

/// Returns whether a Bonk sphere and triangle overlap.
/// 
/// @param sphere
/// @param triangle

function BonkBoolSphereInTriangle(_sphere, _triangle)
{
    with(_sphere)
    {
        var _radius = radius;
        var _sphX = x;
        var _sphY = y;
        var _sphZ = z;
    }
    
    with(_triangle)
    {
        var _triX1 = x1;
        var _triY1 = y1;
        var _triZ1 = z1;
        
        var _triX2 = x2;
        var _triY2 = y2;
        var _triZ2 = z2;
        
        var _triX3 = x3;
        var _triY3 = y3;
        var _triZ3 = z3;
        
        var _dX12 = _triX2 - _triX1;
        var _dY12 = _triY2 - _triY1;
        var _dZ12 = _triZ2 - _triZ1;
        var _dX31 = _triX1 - _triX3;
        var _dY31 = _triY1 - _triY3;
        var _dZ31 = _triZ1 - _triZ3;
        
        var _normalX = _dZ12*_dY31 - _dY12*_dZ31;
        var _normalY = _dX12*_dZ31 - _dZ12*_dX31;
        var _normalZ = _dY12*_dX31 - _dX12*_dY31;
        
        var _length = sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
        if (_length <= 0)
        {
            return false;
        }
        
        _normalX /= _length
        _normalY /= _length;
        _normalZ /= _length;
    }
    
    //Distance from the sphere's centre to the plane
    var _dist = dot_product_3d(_sphX - _triX1, _sphY - _triY1, _sphZ - _triZ1, _normalX, _normalY, _normalZ);
    
    //Early out if the sphere is too far away from the plane
    if ((_dist < -_radius) || (_dist > _radius))
    {
        return false;
    }
    
    //Point on the plane closest to the sphere's centre
    var _pX = _sphX - _normalX*_dist;
    var _pY = _sphY - _normalY*_dist;
    var _pZ = _sphZ - _normalZ*_dist;
    
    var _dX23 = _triX3 - _triX2;
    var _dY23 = _triY3 - _triY2;
    var _dZ23 = _triZ3 - _triZ2;
    
    var _cross1 = variable_clone(__BonkCrossProduct(_pX - _triX1, _pY - _triY1, _pZ - _triZ1, _dX12, _dY12, _dZ12));
    var _cross2 = variable_clone(__BonkCrossProduct(_pX - _triX2, _pY - _triY2, _pZ - _triZ2, _dX23, _dY23, _dZ23));
    var _cross3 = variable_clone(__BonkCrossProduct(_pX - _triX3, _pY - _triY3, _pZ - _triZ3, _dX31, _dY31, _dZ31));
    
    var _dot1 = dot_product_3d(_cross1.x, _cross1.y, _cross1.z, _normalX, _normalY, _normalZ);
    var _dot2 = dot_product_3d(_cross2.x, _cross2.y, _cross2.z, _normalX, _normalY, _normalZ);
    var _dot3 = dot_product_3d(_cross3.x, _cross3.y, _cross3.z, _normalX, _normalY, _normalZ);
    
    if ((_dot1 >= 0) && (_dot2 >= 0) && (_dot3 >= 0))
    {
        return true;
    }
    else
    {
        var _funcClosestPoint = function(_pX, _pY, _pZ, _x1, _y1, _z1, _dX, _dY, _dZ)
        {
            static _result = {};
            
            var _t = dot_product_3d(_pX - _x1, _pY - _y1, _pZ - _z1,   _dX, _dY, _dZ) / (_dX*_dX + _dY*_dY + _dZ*_dZ);
            _t = clamp(_t, 0, 1);
            
            with(_result)
            {
                x = _x1 + _t*_dX;
                y = _y1 + _t*_dY;
                z = _z1 + _t*_dZ;
            }
            
            return _result;
        }
        
        var _radiusSqr = _radius*_radius;
        
        //edge 1 -> 2
        var _pointEdge12 = _funcClosestPoint(_pX, _pY, _pZ,   _triX1, _triY1, _triZ1,   _dX12, _dY12, _dZ12);
        var _vX = _sphX - _pointEdge12.x;
        var _vY = _sphY - _pointEdge12.y;
        var _vZ = _sphZ - _pointEdge12.z;
        var _distSqrEdge12 = _vX*_vX + _vY*_vY + _vZ*_vZ;
        
        //edge 2 -> 3
        var _pointEdge23 = _funcClosestPoint(_pX, _pY, _pZ,   _triX2, _triY2, _triZ2,   _dX23, _dY23, _dZ23);
        var _vX = _sphX - _pointEdge23.x;
        var _vY = _sphY - _pointEdge23.y;
        var _vZ = _sphZ - _pointEdge23.z;
        var _distSqrEdge23 = _vX*_vX + _vY*_vY + _vZ*_vZ;
        
        //edge 3 -> 1
        var _pointEdge31 = _funcClosestPoint(_pX, _pY, _pZ,   _triX3, _triY3, _triZ3,   _dX31, _dY31, _dZ31);
        var _vX = _sphX - _pointEdge31.x;
        var _vY = _sphY - _pointEdge31.y;
        var _vZ = _sphZ - _pointEdge31.z;
        var _distSqrEdge31 = _vX*_vX + _vY*_vY + _vZ*_vZ;
        
        return ((_distSqrEdge12 < _radiusSqr) || (_distSqrEdge23 < _radiusSqr) || (_distSqrEdge31 < _radiusSqr));
    }
}