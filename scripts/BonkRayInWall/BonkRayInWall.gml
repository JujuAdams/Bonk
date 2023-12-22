// Feather disable all

/// @param ray
/// @param wall

function BonkRayInWall(_ray, _wall)
{
    with(_ray)
    {
        //If both plane share a point on the plane then they have to collide
        if ((x == _wall.x) && (y == _wall.y) && (z == _wall.z)) return true;
        
        var _dot = dot_product_3d(xNormal, yNormal, zNormal, _wall.xNormal, _wall.yNormal, _wall.zNormal);
        
        //If the planes aren't parallel then they must collide between the origin and infinity
        if (abs(_dot) != 1) return true;
        
        //We know the planes are parallel
        //If the projection of a point on our plane with our normal is the same as the projection as a point on the other plane then the plane are coincident
        return (dot_product_3d(x, y, z, xNormal, yNormal, zNormal) == dot_product_3d(_wall.x, _wall.y, _wall.z, xNormal, yNormal, zNormal));
    }
}