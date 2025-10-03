// Feather disable all

/// Returns whether a Bonk sphere and quad overlap.
/// 
/// @param sphere
/// @param quad

// TODO - Optimize

function BonkSphereTouchQuad(_sphere, _quad)
{
    with(_sphere)
    {
        var _sphereRadius = radius;
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
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
        
        var _dX12 = dX12;
        var _dY12 = dY12;
        var _dZ12 = dZ12;
        
        var _dX23 = dX24;
        var _dY23 = dY24;
        var _dZ23 = dZ24;
        
        var _dX34 = dX43;
        var _dY34 = dY43;
        var _dZ34 = dZ43;
        
        var _dX41 = dX31;
        var _dY41 = dY31;
        var _dZ41 = dZ31;
        
        var _edgeSqrLength12 = lengthSqr12;
        var _edgeSqrLength23 = lengthSqr24;
        var _edgeSqrLength34 = lengthSqr43;
        var _edgeSqrLength41 = lengthSqr31;
        
        var _normalX = normalX;
        var _normalY = normalY;
        var _normalZ = normalZ;
    }
    
    //Distance from the sphere's centre to the plane
    var _refToPlaneDist = dot_product_3d(_sphereX - _quadX1, _sphereY - _quadY1, _sphereZ - _quadZ1, _normalX, _normalY, _normalZ);
    
    //Early out if the sphere is too far away from the plane
    if ((_refToPlaneDist < -_sphereRadius) || (_refToPlaneDist > _sphereRadius))
    {
        return false;
    }
    
    //Point on the plane closest to the sphere's centre
    var _refX = _sphereX - _normalX*_refToPlaneDist;
    var _refY = _sphereY - _normalY*_refToPlaneDist;
    var _refZ = _sphereZ - _normalZ*_refToPlaneDist;
    
    //Check the reference point is on the inner side of the edge 1->2
    //If we fail, these values fall through
    var _tempX = _refX - _quadX1;
    var _tempY = _refY - _quadY1;
    var _tempZ = _refZ - _quadZ1;
    
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
        var _tempX = _refX - _quadX2;
        var _tempY = _refY - _quadY2;
        var _tempZ = _refZ - _quadZ2;
        
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
            var _tempX = _refX - _quadX3;
            var _tempY = _refY - _quadY3;
            var _tempZ = _refZ - _quadZ3;
            
            var _edgeSqrLen = _edgeSqrLength34;
            var _edgeX = _dX34;
            var _edgeY = _dY34;
            var _edgeZ = _dZ34;
            
            if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                               _tempX*_edgeZ - _tempZ*_edgeX,
                               _tempY*_edgeX - _tempX*_edgeY,
                               _normalX, _normalY, _normalZ) > 0)
            {
                //Check the reference point is on the inner side of the edge 3->1
                //If we fail, these values fall through
                var _tempX = _refX - _quadX4;
                var _tempY = _refY - _quadY4;
                var _tempZ = _refZ - _quadZ4;
                
                var _edgeSqrLen = _edgeSqrLength41;
                var _edgeX = _dX41;
                var _edgeY = _dY41;
                var _edgeZ = _dZ41;
                
                if (dot_product_3d(_tempZ*_edgeY - _tempY*_edgeZ,
                                   _tempX*_edgeZ - _tempZ*_edgeX,
                                   _tempY*_edgeX - _tempX*_edgeY,
                                   _normalX, _normalY, _normalZ) > 0)
                {
                    //Reference point is inside the triangle
                    return true;
                }
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
        return false;
    }
    
    if (_pushLength >= _sphereRadius)
    {
        return false;
    }
    
    return true;
}