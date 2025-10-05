// Feather disable all

/// @param capsule
/// @param triangle
/// @param [struct]

function BonkCapsuleCollideTriangle(_capsule, _triangle, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    with(_capsule)
    {
        var _capsuleHeight = height - 2*radius;
        var _capsuleRadius = radius;
        
        var _capsuleX = x;
        var _capsuleY = y;
        var _capsuleZ = z - 0.5*height + radius;
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
        
        var _dX12 = __bonkDX12;
        var _dY12 = __bonkDY12;
        var _dZ12 = __bonkDZ12;
        
        var _dX23 = __bonkDX23;
        var _dY23 = __bonkDY23;
        var _dZ23 = __bonkDZ23;
        
        var _dX31 = __bonkDX31;
        var _dY31 = __bonkDY31;
        var _dZ31 = __bonkDZ31;
        
        var _normalX = normalX;
        var _normalY = normalY;
        var _normalZ = normalZ;
        
        var _edgeSqrLength12 = __bonkLengthSqr12;
        var _edgeSqrLength23 = __bonkLengthSqr23;
        var _edgeSqrLength31 = __bonkLengthSqr31;
    }
    
    if (_normalZ == 0)
    {
        var _penDepth = clamp(_triZ1 - _capsuleZ, 0, _capsuleHeight);
    }
    else
    {
        var _penDepth = undefined;
        
        var _trace = dot_product_3d(_triX1 - _capsuleX, _triY1 - _capsuleY, _triZ1 - _capsuleZ, _normalX, _normalY, _normalZ) / _normalZ;
        var _traceX = _capsuleX;
        var _traceY = _capsuleY;
        var _traceZ = _capsuleZ + _trace;
        
        //Check the intersection point is on the inner side of the edge 1->2
        //If we fail, these values fall through
        var _tempX = _traceX - _triX1;
        var _tempY = _traceY - _triY1;
        var _tempZ = _traceZ - _triZ1;
        
        var _edgeSqrLen = _edgeSqrLength12;
        var _edgeX = _dX12;
        var _edgeY = _dY12;
        var _edgeZ = _dZ12;
        
        if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                           _tempX*_edgeZ - _tempZ*_edgeX,
                           _tempY*_edgeX - _tempX*_edgeY,
                           _normalX, _normalY, _normalZ) > 0)
        {
            
            //Check the intersection point is on the inner side of the edge 2->3
            //If we fail, these values fall through
            _tempX = _traceX - _triX2;
            _tempY = _traceY - _triY2;
            _tempZ = _traceZ - _triZ2;
            
            _edgeSqrLen = _edgeSqrLength23;
            _edgeX = _dX23;
            _edgeY = _dY23;
            _edgeZ = _dZ23;
            
            if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                               _tempX*_edgeZ - _tempZ*_edgeX,
                               _tempY*_edgeX - _tempX*_edgeY,
                               _normalX, _normalY, _normalZ) > 0)
            {
                
                //Check the intersection point is on the inner side of the edge 3->1
                //If we fail, these values fall through
                _tempX = _traceX - _triX3;
                _tempY = _traceY - _triY3;
                _tempZ = _traceZ - _triZ3;
                
                _edgeSqrLen = _edgeSqrLength31;
                _edgeX = _dX31;
                _edgeY = _dY31;
                _edgeZ = _dZ31;
                
                if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                                   _tempX*_edgeZ - _tempZ*_edgeX,
                                   _tempY*_edgeX - _tempX*_edgeY,
                                   _normalX, _normalY, _normalZ) > 0)
                {
                    _penDepth = clamp(_trace, 0, _capsuleHeight);
                }
            }
        }
        
        if (_penDepth == undefined)
        {
            //Catch intersection points that are outside the triangle
            
            //Work backwards to get the original vertex z component
            var _triZ = _tempZ - _trace;
            
            //The projection of the edge vector onto the capsule axis will always just be the z-component because
            //the axis vector is {0,0,1}
            if (_edgeZ*_edgeZ == _edgeSqrLen)
            {
                _penDepth = clamp(_triZ, 0, _capsuleHeight);
            }
            else
            {
                var _gradient = clamp((_tempX*_edgeX + _tempY*_edgeY) / (_edgeSqrLen - _edgeZ*_edgeZ), 0, 1);
                _penDepth = clamp(_gradient*_edgeZ - _triZ, 0, _capsuleHeight);
            }
        }
    }
    
    var _refX = _capsuleX;
    var _refY = _capsuleY;
    var _refZ = _capsuleZ + _penDepth;
    
    //Check the reference point is on the inner side of the edge 1->2
    //If we fail, these values fall through
    var _tempX = _refX - _triX1;
    var _tempY = _refY - _triY1;
    var _tempZ = _refZ - _triZ1;
    
    //Sneaky distance-to-plane check as an early-out
    var _refToPlaneDist = dot_product_3d(_tempX, _tempY, _tempZ, _normalX, _normalY, _normalZ);
    if (abs(_refToPlaneDist) > _capsuleRadius)
    {
        return _reaction.__Null();
    }
    
    _edgeSqrLen = _edgeSqrLength12;
    _edgeX = _dX12;
    _edgeY = _dY12;
    _edgeZ = _dZ12;
    
    if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                       _tempX*_edgeZ - _tempZ*_edgeX,
                       _tempY*_edgeX - _tempX*_edgeY,
                       _normalX, _normalY, _normalZ) > 0)
    {
        //Check the reference point is on the inner side of the edge 2->3
        //If we fail, these values fall through
        _tempX = _refX - _triX2;
        _tempY = _refY - _triY2;
        _tempZ = _refZ - _triZ2;
        
        _edgeSqrLen = _edgeSqrLength23;
        _edgeX = _dX23;
        _edgeY = _dY23;
        _edgeZ = _dZ23;
        
        if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                           _tempX*_edgeZ - _tempZ*_edgeX,
                           _tempY*_edgeX - _tempX*_edgeY,
                           _normalX, _normalY, _normalZ) > 0)
        {
            //Check the reference point is on the inner side of the edge 3->1
            //If we fail, these values fall through
            _tempX = _refX - _triX3;
            _tempY = _refY - _triY3;
            _tempZ = _refZ - _triZ3;
            
            _edgeSqrLen = _edgeSqrLength31;
            _edgeX = _dX31;
            _edgeY = _dY31;
            _edgeZ = _dZ31;
            
            if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                               _tempX*_edgeZ - _tempZ*_edgeX,
                               _tempY*_edgeX - _tempX*_edgeY,
                               _normalX, _normalY, _normalZ) > 0)
            {
                //Reference point is inside the triangle
                
                if (_refToPlaneDist == 0)
                {
                    //If the reference point is on the plane then ...
                    
                    if (_normalZ > 0)
                    {
                        //Push the capsule up if the triangle is up-facing
                        var _pushLength = _capsuleRadius + (_penDepth / _normalZ);
                    }
                    else if (_normalZ < 0)
                    {
                        //Push the capsule down if the triangle is down-facing
                        var _pushLength = _capsuleRadius + ((_capsuleHeight - _penDepth) / _normalZ);
                    }
                    else
                    {
                        //Push the capsule sideways out if the triangle plane is perfectly vertical
                        var _pushLength = _capsuleRadius;
                    }
                }
                else
                {
                    //The reference point is inside the triangle but not exactly on the plane
                    //This happens when the very end of a cap intersects the plane
                    var _pushLength = sign(_refToPlaneDist) * (_capsuleRadius - abs(_refToPlaneDist));
                }
                
                with(_reaction)
                {
                    shape = _triangle;
                    
                    dX = _pushLength*_normalX;
                    dY = _pushLength*_normalY;
                    dZ = _pushLength*_normalZ;
                }
                
                return _reaction;
            }
        }
    }
    
    //Catch reference point that is outside the triangle
    
    //Calculate the direction to push the reference point away from the triangle. This is the perpendicular
    //vector from the edge to the reference point
    var _dot = clamp(dot_product_3d(_edgeX, _edgeY, _edgeZ, _tempX, _tempY, _tempZ) / _edgeSqrLen, 0, 1);
    var _pushX = _tempX - _dot*_edgeX; 
    var _pushY = _tempY - _dot*_edgeY;
    var _pushZ = _tempZ - _dot*_edgeZ;
    
    var _pushLength = point_distance_3d(0, 0, 0, _pushX, _pushY, _pushZ);
    if (_pushLength == 0)
    {
        //TODO - Handle this edge case
        return _reaction.__Null();
    }
    
    if (_pushLength >= _capsuleRadius)
    {
        return _reaction.__Null();
    }
    
    with(_reaction)
    {
        shape = _triangle;
        
        //Push out just enough so that the surface of the capsule is touching the triangle
        var _coeff = (_capsuleRadius - _pushLength) / _pushLength;
        dX = _coeff*_pushX;
        dY = _coeff*_pushY;
        dZ = _coeff*_pushZ;
    }
    
    return _reaction;
}