// Feather disable all

/// Constructor that generates a z-aligned cylinder. Cylinders can check against the following
/// shapes:
/// - AAB
/// - Capsule
/// - Cylinder
/// - Sphere
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.SetHeight([height])`
/// 
/// `.SetRadius([radius])`
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
///     Coordinate of the centre of the cylinder.
/// 
/// `.height`
///     Total height of the cylinder.
/// 
/// `.radius`
///     Radius of the cylinder.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius

function BonkCylinder(_x, _y, _z, _height, _radius) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_CYLINDER;
    static lineHitFunction = BonkLineHitCylinder;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCylinderCollideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCylinderCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCylinderCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCylinderCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCylinderInsideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCylinderInsideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCylinderInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderInsideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCylinderInsideSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    radius = _radius;
    
    __instanceXY = instance_create_depth(_x, _y, 0, __BonkShapeSurrogateXY);
    __instanceXY.__shape = self;
    __instanceXY.sprite_index = __BonkMaskCircle;
    __instanceXY.image_xscale = 2*_radius / __BONK_MASK_SIZE;
    __instanceXY.image_yscale = 2*_radius / __BONK_MASK_SIZE;
    
    __instanceXZ = instance_create_depth(_x, _y, 0, __BonkShapeSurrogateXZ);
    __instanceXZ.__shape = self;
    __instanceXZ.sprite_index = __BonkMaskAAB;
    __instanceXZ.image_xscale = 2*_radius / __BONK_MASK_SIZE;
    __instanceXZ.image_yscale =   _height / __BONK_MASK_SIZE;
    
    
    
    static __SetPositionFree = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        __instanceXY.x = _x;
        __instanceXY.y = _y;
        __instanceXZ.x = _x;
        __instanceXZ.y = _z;
        
        return self;
    }
    
    static __SetPositionInWorld = function(_x = x, _y = y, _z = z)
    {
        __world.__MoveShape(_x - x, _y - y, _z - z, self);
        
        x = _x;
        y = _y;
        z = _z;
        
        __instanceXY.x = _x;
        __instanceXY.y = _y;
        __instanceXZ.x = _x;
        __instanceXZ.y = _z;
        
        return self;
    }
    
    SetPosition = __SetPositionFree;
    
    static SetHeight = function(_height = height)
    {
        height = _height;
        
        __instanceXZ.image_yscale = _height / __BONK_MASK_SIZE;
        
        return self;
    }
    
    static SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        __instanceXY.image_xscale = 2*_radius / __BONK_MASK_SIZE;
        __instanceXY.image_yscale = 2*_radius / __BONK_MASK_SIZE;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x - radius,
            yMin: y - radius,
            zMin: z - 0.5*height,
            xMax: x + radius,
            yMax: y + radius,
            zMax: z + 0.5*height,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCylinder(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}