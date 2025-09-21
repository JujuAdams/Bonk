// Feather disable all

/// Constructor that generates an axis-aligned box. Axis-aligned boxes can check against the
/// following shapes:
/// - AAB
/// - Capsule
/// - Cylinder
/// - Sphere
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.SetSize([dX], [dY], [dZ])`
/// 
/// `.GetAABB()`
///     Returns a struct containing the bounding box for the shape.
/// 
/// `.Draw([color], [thickness], [wireframe])`
///     Draws the shape. This uses Ugg, please see https://github.com/jujuadams/Ugg
/// 
/// `.Inside(otherShape)`
///     Returns whether the two shapes overlap. Not all shapes can be checked against, see above.
/// 
/// `.Collide(otherShape)`
///     Returns the vector that separates two overlapping shapes. Not all shapes can be checked
///     against, see above. This method returns a struct that contains the following variables:
///     
///     `.collision`
///         Whether a collision was found. If no collision is found, this variable is set to `false`.
///     
///     `.x` `.y` `.z`
///         The vector that separates the two shapes. If there is no collision, all three variables
///         will be set to `0`.
/// 
///     N.B. The returned struct is statically allocated. Reusing `.Collide()` may cause the same struct
///          to be returned.
/// 
/// `.PushOut(subjectShape, [slopeThreshold=0])`
///     Pushes the subject shape out of the scoped shape (provided that the two shapes can collide,
///     see above). The slope threshold will allow shapes to "stand" on slopes instead of sliding
///     down them. The units of this parameter are degrees. An angle of `0` represents a perfectly
///     horizontal floor plane. Increase this value to allow shapes to stand on steeper slopes.
/// 
/// The struct created by the constructor contains the following values:
/// 
/// `.x` `.y` `.z`
///     Coordinate of the centre of the box.
/// 
/// `.xSize` `.ySize` `.zSize`
///     Size of the box in each axis.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize

function BonkAAB(_x, _y, _z, _xSize, _ySize, _zSize) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_AAB;
    static lineHitFunction = BonkLineHitAAB;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABCollideAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABInsideAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABInsideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABInsideSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    
    
    static __SetPositionFree = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static __SetPositionInWorld = function(_x = x, _y = y, _z = z)
    {
        __world.__MoveShape(_x - x, _y - y, _z - z, self);
        
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    SetPosition = __SetPositionFree;
    
    static RemoveFromWorld = function()
    {
        if (__world != undefined)
        {
            __world.__RemoveShape(self);
            SetPosition = __SetPositionFree;
        }
    }
    
    static SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x - 0.5*xSize,
            yMin: y - 0.5*ySize,
            zMin: z - 0.5*zSize,
            xMax: x + 0.5*xSize,
            yMax: y + 0.5*ySize,
            zMax: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, xSize, ySize, zSize, _color, _wireframe);
    }
}