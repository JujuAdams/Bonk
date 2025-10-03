// Feather disable all

/// Constructor that generates a box that can be rotated around the z-axis. Rotated boxes can check
/// against the following shapes:
/// - Capsule
/// - Cylinder
/// - Sphere
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.SetSize([dX], [dY], [dZ])`
/// 
/// `.SetRotation([zRotation])`
/// 
/// `.GetAABB()`
///     Returns a struct containing the bounding box for the shape.
/// 
/// `.Draw([color], [thickness], [wireframe])`
///     Draws the shape. This uses Ugg, please see https://github.com/jujuadams/Ugg
/// 
/// `.Touch(otherShape)`
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
/// `.zRotation`
///     Rotation of the box around the z-axis.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation

function BonkStructRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_OBB;
    static __lineHitFunction = BonkLineHitRotatedBox;
    
    static __collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxCollideSphere;
        return _array;
    })();
    
    static __insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxTouchSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    zRotation = _zRotation;
    
    
    
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
    
    static SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        return self;
    }
    
    static SetRotation = function(_zRotation = zRotation)
    {
        zRotation = _zRotation;
        
        return self;
    }
    
    static GetAABB = function()
    {
        //TODO - Do this properly
        return {
            xMin: x - sqrt(2)*max(xSize, ySize),
            yMin: y - sqrt(2)*max(xSize, ySize),
            zMin: z - 0.5*zSize,
            xMax: x + sqrt(2)*max(xSize, ySize),
            yMax: y + sqrt(2)*max(xSize, ySize),
            zMax: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z,   xSize, ySize, zSize,  zRotation,   _color, _wireframe);
    }
}