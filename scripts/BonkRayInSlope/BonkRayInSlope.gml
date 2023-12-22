// Feather disable all

/// @param ray
/// @param slope

function BonkRayInSlope(_ray, _slope)
{
    with(_ray)
    {
        //If both plane share a point on the plane then they have to collide
        if ((x == _slope.x) && (y == _slope.y) && (z == _slope.z)) return true;
        
        var _dot = dot_product_3d(xNormal, yNormal, zNormal, _slope.xNormal, _slope.yNormal, _slope.zNormal);
        
        //If the planes aren't parallel then they must collide between the origin and infinity
        if (abs(_dot) != 1) return true;
        
        //We know the planes are parallel
        //If the projection of a point on our plane with our normal is the same as the projection as a point on the other plane then the plane are coincident
        return (dot_product_3d(x, y, z, xNormal, yNormal, zNormal) == dot_product_3d(_slope.x, _slope.y, _slope.z, xNormal, yNormal, zNormal));
    }
}