// Feather disable all

function __BonkSphereCollideTriangle(_sphereX, _sphereY, _sphereZ, _sphereRadius,   _triangleShape,   _triX1, _triY1, _triZ1,   _triX2, _triY2, _triZ2,   _triX3, _triY3, _triZ3,    _dX12, _dY12, _dZ12,    _dX23, _dY23, _dZ23,    _dX31, _dY31, _dZ31,   _normalX, _normalY, _normalZ,   _edgeSqrLength12, _edgeSqrLength23, _edgeSqrLength31,   _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    //Distance from the sphere's centre to the plane
    var _refToPlaneDist = dot_product_3d(_sphereX - _triX1, _sphereY - _triY1, _sphereZ - _triZ1, _normalX, _normalY, _normalZ);
    
    //Early out if the sphere is too far away from the plane
    if ((_refToPlaneDist < -_sphereRadius) || (_refToPlaneDist > _sphereRadius))
    {
        return _reaction.__Null();
    }
    
    //Point on the plane closest to the sphere's centre
    var _refX = _sphereX - _normalX*_refToPlaneDist;
    var _refY = _sphereY - _normalY*_refToPlaneDist;
    var _refZ = _sphereZ - _normalZ*_refToPlaneDist;
    
    //Check the reference point is on the inner side of the edge 1->2
    //If we fail, these values fall through
    var _tempX = _refX - _triX1;
    var _tempY = _refY - _triY1;
    var _tempZ = _refZ - _triZ1;
    
    var _edgeSqrLen = _edgeSqrLength12;
    var _edgeX = _dX12;
    var _edgeY = _dY12;
    var _edgeZ = _dZ12;
    
    if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                       _tempX*_edgeZ - _tempZ*_edgeX,
                       _tempY*_edgeX - _tempX*_edgeY,
                       _normalX, _normalY, _normalZ) > 0)
    {
        //Check the reference point is on the inner side of the edge 2->3
        //If we fail, these values fall through
        var _tempX = _refX - _triX2;
        var _tempY = _refY - _triY2;
        var _tempZ = _refZ - _triZ2;
        
        var _edgeSqrLen = _edgeSqrLength23;
        var _edgeX = _dX23;
        var _edgeY = _dY23;
        var _edgeZ = _dZ23;
        
        if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                           _tempX*_edgeZ - _tempZ*_edgeX,
                           _tempY*_edgeX - _tempX*_edgeY,
                           _normalX, _normalY, _normalZ) > 0)
        {
            //Check the reference point is on the inner side of the edge 3->1
            //If we fail, these values fall through
            var _tempX = _refX - _triX3;
            var _tempY = _refY - _triY3;
            var _tempZ = _refZ - _triZ3;
            
            var _edgeSqrLen = _edgeSqrLength31;
            var _edgeX = _dX31;
            var _edgeY = _dY31;
            var _edgeZ = _dZ31;
            
            if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                               _tempX*_edgeZ - _tempZ*_edgeX,
                               _tempY*_edgeX - _tempX*_edgeY,
                               _normalX, _normalY, _normalZ) > 0)
            {
                //Reference point is inside the triangle
                
                with(_reaction)
                {
                    shape = _triangleShape;
                    
                    var _pushLength = sign(_refToPlaneDist) * (_sphereRadius - abs(_refToPlaneDist));
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
    var _pushX = _sphereX - (_refX - _tempX + _dot*_edgeX); 
    var _pushY = _sphereY - (_refY - _tempY + _dot*_edgeY);
    var _pushZ = _sphereZ - (_refZ - _tempZ + _dot*_edgeZ);
    
    var _pushLength = point_distance_3d(0, 0, 0, _pushX, _pushY, _pushZ);
    if (_pushLength == 0)
    {
        //TODO - Handle this edge case
        return _reaction.__Null();
    }
    
    if (_pushLength >= _sphereRadius)
    {
        return _reaction.__Null();
    }
    
    with(_reaction)
    {
        shape = _triangleShape;
        
        //Push out just enough so that the surface of the capsule is touching the triangle
        var _coeff = (_sphereRadius - _pushLength) / _pushLength;
        dX = _coeff*_pushX;
        dY = _coeff*_pushY;
        dZ = _coeff*_pushZ;
    }
    
    return _reaction;
}