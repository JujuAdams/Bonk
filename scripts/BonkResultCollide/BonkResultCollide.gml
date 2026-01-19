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

function BonkResultCollide() constructor
{
    shape = undefined;
    
    dX = 0;
    dY = 0;
    dZ = 0;
    
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
        
        return $"\{\"shape\":\"{_shape}\",\"dX\":{dX},\"dY\":{dY},\"dZ\":{dZ}\}";
    }
    
    static __Null = function()
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