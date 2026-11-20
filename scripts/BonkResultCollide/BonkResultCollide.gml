// Feather disable all

/// Returned by all "collide" functions (e.g. `BonkCylinderCollideCylinder()`) and is also part of
/// deflect data (please see `BonkResultDeflect()`). You'll almost certainly never need to create
/// one of these structs yourself.
/// 
/// Structs created by the constructor contain the following variables:
/// 
/// `.dX` `.dY` `.dZ`
///   The displacement required to separate the two colliding shapes.
///
/// `.shape`
///   The shape that was collided with. If this variable is set to `undefined` then no collision
///   was found.
/// 
/// Structs created by the constructor contain the following method too:
/// 
/// `.GetFloor([slopeThreshold=0])`
///   Returns `true` if  the collision is with a flat surface in the XY plane and `false` otherwise.
///   The `slopeThreshold` parameter is measured in degrees and referes to the gradient angle of
///   colliding surfaces that a shape has bumped into. A slope threshold of `0` degrees is a
///   horizontal floor, a slope threshold of `90` degrees is a vertical wall.

function BonkResultCollide() constructor
{
    shape = undefined;
    
    dX = 0;
    dY = 0;
    dZ = 0;
    
    static toString = function()
    {
        if (shape == undefined)
        {
            return "<no collision>";
        }
        else
        {
            return $"<collision {dX}, {dY}, {dZ} / shape {shape}>";
        }
    }
    
    static GetFloor = function(_slopeThreshold = 0)
    {
        return (GetGradient() > max(dcos(_slopeThreshold), 0));
    }
    
    static GetMagnitude = function()
    {
        return point_distance_3d(0, 0, 0, dX, dY, dZ);
    }
    
    static GetSlope = function()
    {
        var _dX = dX;
        var _dY = dY;
        var _dZ = dZ;
        
        return (_dZ / max(0.00001, sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ)));
    }
    
    static GetSlopeAngle = function()
    {
        return darccos(GetSlope());
    }
    
    static Null = function()
    {
        shape = undefined;
        
        dX = 0;
        dY = 0;
        dZ = 0;
        
        return self;
    }
    
    static __Reverse = function(_shape)
    {
        if (shape != undefined)
        {
            shape = _shape;
        }
        
        dX = -dX;
        dY = -dY;
        dZ = -dZ;
        
        return self;
    }
    
    static __CopyTo = function(_other)
    {
        _other.shape = shape;
        
        _other.dX = dX;
        _other.dY = dY;
        _other.dZ = dZ;
        
        return _other;
    }
}