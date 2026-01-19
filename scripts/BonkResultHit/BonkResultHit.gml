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
    
    static toString = function()
    {
        if (instance_exists(shape))
        {
            var _shape = $"{object_get_name(shape.object_index)} {string(real(shape.id))}";
        }
        else if (is_struct(shape))
        {
            var _shape = $"{instanceof(shape)} {string_delete(string(ptr(shape)), 1, 8)}";
        }
        else
        {
            var _shape = "<none>";
        }
        
        return $"\{\"shape\":\"{_shape}\",\"x\":{x},\"y\":{y},\"z\":{z},\"normalX\": {normalX},\"normalY\":{normalY},\"normalZ\":{normalZ}\}";
    }
    
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
        
        _other.x = x;
        _other.y = y;
        _other.z = z;
        
        _other.normalX = normalX;
        _other.normalY = normalY;
        _other.normalZ = normalZ;
        
        return _other;
    }
}