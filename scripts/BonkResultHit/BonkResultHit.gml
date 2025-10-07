// Feather disable all

/// Returned by all "hit" functions (e.g. `BonkRayHitSphere()`). You'll almost certainly never need
/// to create one of these structs yourself.
/// 
/// Structs created by the constructor contain the following variables:
/// 
/// `.x` `.y` `.z`
///   The point where the line/ray hit the shape.
/// 
/// `.normalX `.normalY` `.normalZ`
///   The normal of the surface where the line/ray hits the shape.
///
/// `.shape`
///   The shape that was hit. If this variable is set to `undefined` then no hit was found.

function BonkResultHit() constructor
{
    shape = undefined;
    
    x = 0;
    y = 0;
    z = 0;
    
    normalX = 0;
    normalY = 0;
    normalZ = 1;
    
    static __Null = function()
    {
        shape = undefined;
        
        x = 0;
        y = 0;
        z = 0;
        
        normalX = 0;
        normalY = 0;
        normalZ = 1;
        
        return self;
    }
    
    static __CopyTo = function(_other)
    {
        _other.shape = shape;
        
        x = _other.x;
        y = _other.y;
        z = _other.z;
        
        normalX = _other.normalX;
        normalY = _other.normalY;
        normalZ = _other.normalZ;
        
        return _other;
    }
}