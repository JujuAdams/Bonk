// Feather disable all

/// Constructor that generates an infinitesimal point.
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.GetAABB()`
/// 
/// `.Draw([color], [thickness], [wireframe])`
///     Draws the shape. This uses Ugg, please see https://github.com/jujuadams/Ugg
/// 
/// `.Touch(otherShape)`
///     Checks whether the line hits another shape. You may check against the following shapes:
///     - Axis-Aligned Box
///     - Capsule
///     - Cylinder
///     - Sphere
/// 
/// The struct created by the constructor contains the following values:
/// 
/// `.x` `.y` `.z` 
///     Coordinate of the point.
/// 
/// @param x
/// @param y
/// @param z

function BonkPoint(_x, _y, _z) constructor
{
    static bonkType = BONK_TYPE_POINT;
    static LineHit = __BonkReturnNullHit;
    
    static __insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkPointTouchAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkPointTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkPointTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkPointTouchSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggPoint(x, y, z, _color, _wireframe);
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x,
            yMin: y,
            zMin: z,
            xMax: x,
            yMax: y,
            zMax: z,
        };
    }
    
    static Touch = function(_otherShape)
    {
        var _insideFunc = __insideFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(_otherShape, x, y, z);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkError($".Touch() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
}