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
/// `.Inside(otherShape)`
/// Checks whether the line hits another shape. You may check against the following shapes:
///     Axis-Aligned Box
///     Capsule
///     Cylinder
///     Sphere
/// 
/// The struct created by the constructor contains the following values:
/// 
/// `.x` `.y` `.z` 
///     Coordinate of the point.
/// 
/// @param x
/// @param y
/// @param z

function BonkPoint(_x, _y, _z) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_POINT;
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCoordInsideAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCoordInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCoordInsideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCoordInsideSphere;
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
    
    static Inside = function(_otherShape)
    {
        var _insideFunc = _insideFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(_otherShape, x, y, z);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkError($".Inside() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
}