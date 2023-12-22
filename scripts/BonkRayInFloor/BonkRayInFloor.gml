// Feather disable all

/// @param ray
/// @param floor

function BonkRayInFloor(_ray, _floor)
{
    with(_ray)
    {
        //If both plane share a point on the plane then they have to collide
        if ((x == _floor.x) && (y == _floor.y) && (z == _floor.z)) return true;
        
        var _dot = dot_product_3d(xNormal, yNormal, zNormal, _floor.xNormal, _floor.yNormal, _floor.zNormal);
        
        //If the planes aren't parallel then they must collide between the origin and infinity
        if (abs(_dot) != 1) return true;
        
        //We know the planes are parallel
        //If the projection of a point on our plane with our normal is the same as the projection as a point on the other plane then the plane are coincident
        return (dot_product_3d(x, y, z, xNormal, yNormal, zNormal) == dot_product_3d(_floor.x, _floor.y, _floor.z, xNormal, yNormal, zNormal));
    }
}