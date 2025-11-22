// Feather disable all

/// @param capsule
/// @param quad
/// @param [struct]

function BonkCapsuleCollideQuad(_capsule, _quad, _struct = undefined)
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
    
    with(_quad)
    {
        var _quadX1 = x1;
        var _quadY1 = y1;
        var _quadZ1 = z1;
        
        var _quadX2 = x2;
        var _quadY2 = y2;
        var _quadZ2 = z2;
        
        var _quadX3 = x4;
        var _quadY3 = y4;
        var _quadZ3 = z4;
        
        var _quadX4 = x3;
        var _quadY4 = y3;
        var _quadZ4 = z3;
        
        var _dX12 = __bonkDX12;
        var _dY12 = __bonkDY12;
        var _dZ12 = __bonkDZ12;
        
        var _dX23 = __bonkDX24;
        var _dY23 = __bonkDY24;
        var _dZ23 = __bonkDZ24;
        
        var _dX34 = __bonkDX43;
        var _dY34 = __bonkDY43;
        var _dZ34 = __bonkDZ43;
        
        var _dX41 = __bonkDX31;
        var _dY41 = __bonkDY31;
        var _dZ41 = __bonkDZ31;
        
        var _edgeSqrLength12 = __bonkLengthSqr12;
        var _edgeSqrLength23 = __bonkLengthSqr24;
        var _edgeSqrLength34 = __bonkLengthSqr43;
        var _edgeSqrLength41 = __bonkLengthSqr31;
        
        var _normalX = normalX;
        var _normalY = normalY;
        var _normalZ = normalZ;
    }
    
    if (_normalZ == 0)
    {
        var _penDepth = clamp(_quadZ1 - _capsuleZ, 0, _capsuleHeight);
    }
    else
    {
        var _penDepth = undefined;
        
        var _trace = dot_product_3d(_quadX1 - _capsuleX, _quadY1 - _capsuleY, _quadZ1 - _capsuleZ, _normalX, _normalY, _normalZ) / _normalZ;
        var _traceX = _capsuleX;
        var _traceY = _capsuleY;
        var _traceZ = _capsuleZ + _trace;
        
        //Check the intersection point is on the inner side of the edge 1->2
        //If we fail, these values fall through
        var _tempX = _traceX - _quadX1;
        var _tempY = _traceY - _quadY1;
        var _tempZ = _traceZ - _quadZ1;
        
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
            _tempX = _traceX - _quadX2;
            _tempY = _traceY - _quadY2;
            _tempZ = _traceZ - _quadZ2;
            
            _edgeSqrLen = _edgeSqrLength23;
            _edgeX = _dX23;
            _edgeY = _dY23;
            _edgeZ = _dZ23;
            
            if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                               _tempX*_edgeZ - _tempZ*_edgeX,
                               _tempY*_edgeX - _tempX*_edgeY,
                               _normalX, _normalY, _normalZ) > 0)
            {
                
                //Check the intersection point is on the inner side of the edge 3->4
                //If we fail, these values fall through
                _tempX = _traceX - _quadX3;
                _tempY = _traceY - _quadY3;
                _tempZ = _traceZ - _quadZ3;
                
                _edgeSqrLen = _edgeSqrLength34;
                _edgeX = _dX34;
                _edgeY = _dY34;
                _edgeZ = _dZ34;
                
                if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                                    _tempX*_edgeZ - _tempZ*_edgeX,
                                    _tempY*_edgeX - _tempX*_edgeY,
                                    _normalX, _normalY, _normalZ) > 0)
                {
                    //Check the intersection point is on the inner side of the edge 4->1
                    //If we fail, these values fall through
                    _tempX = _traceX - _quadX4;
                    _tempY = _traceY - _quadY4;
                    _tempZ = _traceZ - _quadZ4;
                    
                    _edgeSqrLen = _edgeSqrLength41;
                    _edgeX = _dX41;
                    _edgeY = _dY41;
                    _edgeZ = _dZ41;
                    
                    if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                                       _tempX*_edgeZ - _tempZ*_edgeX,
                                       _tempY*_edgeX - _tempX*_edgeY,
                                       _normalX, _normalY, _normalZ) > 0)
                    {
                        _penDepth = clamp(_trace, 0, _capsuleHeight);
                    }
                }
            }
        }
        
        if (_penDepth == undefined)
        {
            //Catch intersection points that are outside the quad
            
            //Work backwards to get the original vertex z component
            var _quadZ = _tempZ - _trace;
            
            //The projection of the edge vector onto the capsule axis will always just be the z-component because
            //the axis vector is {0,0,1}
            if (_edgeZ*_edgeZ == _edgeSqrLen)
            {
                _penDepth = clamp(_quadZ, 0, _capsuleHeight);
            }
            else
            {
                var _gradient = clamp((_tempX*_edgeX + _tempY*_edgeY) / (_edgeSqrLen - _edgeZ*_edgeZ), 0, 1);
                _penDepth = clamp(_gradient*_edgeZ - _quadZ, 0, _capsuleHeight);
            }
        }
    }
    
    var _refX = _capsuleX;
    var _refY = _capsuleY;
    var _refZ = _capsuleZ + _penDepth;
    
    //Check the reference point is on the inner side of the edge 1->2
    //If we fail, these values fall through
    var _tempX = _refX - _quadX1;
    var _tempY = _refY - _quadY1;
    var _tempZ = _refZ - _quadZ1;
    
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
        _tempX = _refX - _quadX2;
        _tempY = _refY - _quadY2;
        _tempZ = _refZ - _quadZ2;
        
        _edgeSqrLen = _edgeSqrLength23;
        _edgeX = _dX23;
        _edgeY = _dY23;
        _edgeZ = _dZ23;
        
        if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                           _tempX*_edgeZ - _tempZ*_edgeX,
                           _tempY*_edgeX - _tempX*_edgeY,
                           _normalX, _normalY, _normalZ) > 0)
        {
            //Check the reference point is on the inner side of the edge 4->1
            //If we fail, these values fall through
            _tempX = _refX - _quadX3;
            _tempY = _refY - _quadY3;
            _tempZ = _refZ - _quadZ3;
            
            _edgeSqrLen = _edgeSqrLength34;
            _edgeX = _dX34;
            _edgeY = _dY34;
            _edgeZ = _dZ34;
            
            if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                               _tempX*_edgeZ - _tempZ*_edgeX,
                               _tempY*_edgeX - _tempX*_edgeY,
                               _normalX, _normalY, _normalZ) > 0)
            {
                //Check the reference point is on the inner side of the edge 4->1
                //If we fail, these values fall through
                _tempX = _refX - _quadX4;
                _tempY = _refY - _quadY4;
                _tempZ = _refZ - _quadZ4;
                
                _edgeSqrLen = _edgeSqrLength41;
                _edgeX = _dX41;
                _edgeY = _dY41;
                _edgeZ = _dZ41;
                
                if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                                   _tempX*_edgeZ - _tempZ*_edgeX,
                                   _tempY*_edgeX - _tempX*_edgeY,
                                   _normalX, _normalY, _normalZ) > 0)
                {
                    //Reference point is inside the quad
                    
                    if (_refToPlaneDist == 0)
                    {
                        //If the reference point is on the plane then ...
                    
                        if (_normalZ > 0)
                        {
                            //Push the capsule up if the quad is up-facing
                            var _pushLength = _capsuleRadius + (_penDepth / _normalZ);
                        }
                        else if (_normalZ < 0)
                        {
                            //Push the capsule down if the quad is down-facing
                            var _pushLength = _capsuleRadius + ((_capsuleHeight - _penDepth) / _normalZ);
                        }
                        else
                        {
                            //Push the capsule sideways out if the quad plane is perfectly vertical
                            var _pushLength = _capsuleRadius;
                        }
                    }
                    else
                    {
                        //The reference point is inside the quad but not exactly on the plane
                        //This happens when the very end of a cap intersects the plane
                        var _pushLength = sign(_refToPlaneDist) * (_capsuleRadius - abs(_refToPlaneDist));
                    }
                    
                    with(_reaction)
                    {
                        shape = _quad;
                        
                        dX = _pushLength*_normalX;
                        dY = _pushLength*_normalY;
                        dZ = _pushLength*_normalZ;
                    }
                    
                    return _reaction;
                }
            }
        }
    }
    
    //Catch reference point that is outside the quad
    
    //Calculate the direction to push the reference point away from the quad. This is the perpendicular
    //vector from the edge to the reference point
    var _dot = clamp(dot_product_3d(_edgeX, _edgeY, _edgeZ, _tempX, _tempY, _tempZ) / _edgeSqrLen, 0, 1);
    var _pushX = _tempX - _dot*_edgeX; 
    var _pushY = _tempY - _dot*_edgeY;
    var _pushZ = _tempZ - _dot*_edgeZ;
    
    var _pushLength = point_distance_3d(0, 0, 0, _pushX, _pushY, _pushZ);
    if (_pushLength >= _capsuleRadius)
    {
        return _reaction.__Null();
    }
    
    if (_pushLength == 0)
    {
        //Capsule axis is exactly on the edge
        
        var _pushX = _normalZ*_edgeY - _normalY*_edgeZ;
        var _pushY = _normalX*_edgeZ - _normalZ*_edgeX;
        var _pushZ = _normalY*_edgeX - _normalX*_edgeY;
        var _coeff = 1 / point_distance_3d(0, 0, 0, _pushX, _pushY, _pushZ);
    }
    else
    {
        //Push out just enough so that the surface of the capsule is touching the triangle
        var _coeff = (_capsuleRadius - _pushLength) / _pushLength;
    }
    
    with(_reaction)
    {
        shape = _quad;
        
        dX = _coeff*_pushX;
        dY = _coeff*_pushY;
        dZ = _coeff*_pushZ;
    }
    
    return _reaction;
}