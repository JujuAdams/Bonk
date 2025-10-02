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
/// @param x
/// @param y
/// @param z
/// @param height
/// @param radius
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstCapsule(_x, _y, _z, _height, _radius, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(_x, _y, 0, _objectXY))
    {
        bonkType = BONK_TYPE_CAPSULE;
        lineHitFunction = BonkLineHitCapsule;
        
        static _collideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkCapsuleCollideAAB;
            _array[@ BONK_TYPE_OBB     ] = BonkCapsuleCollideRotatedBox;
            _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleCollideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkCapsuleCollideCylinder;
            _array[@ BONK_TYPE_QUAD    ] = BonkCapsuleCollideQuad;
            _array[@ BONK_TYPE_SPHERE  ] = BonkCapsuleCollideSphere;
            _array[@ BONK_TYPE_TRIANGLE] = BonkCapsuleCollideTriangle;
            return _array;
        })();
        
        static _insideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkCapsuleInsideAAB;
            _array[@ BONK_TYPE_OBB     ] = BonkCapsuleInsideRotatedBox;
            _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleInsideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkCapsuleInsideCylinder;
            _array[@ BONK_TYPE_QUAD    ] = BonkCapsuleInsideQuad;
            _array[@ BONK_TYPE_SPHERE  ] = BonkCapsuleInsideSphere;
            _array[@ BONK_TYPE_TRIANGLE] = BonkCapsuleInsideTriangle;
            return _array;
        })();
        
        __collideFuncLookup = _collideFuncLookup;
        __insideFuncLookup  = _insideFuncLookup;
        
        
        
        z = _z;
        
        height = _height;
        radius = _radius;
        
        
        
        sprite_index = BonkMaskCircle;
        image_xscale = BONK_MASK_SIZE / (2*_radius);
        image_yscale = BONK_MASK_SIZE / (2*_radius);
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                sprite_index = BonkMaskAAB;
                image_xscale = BONK_MASK_SIZE / (2*_radius);
                image_yscale = BONK_MASK_SIZE / _height;
            }
        }
        
        
        
        SetPosition = function(_x = x, _y = y, _z = z)
        {
            x = _x;
            y = _y;
            z = _z;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.x = x;
                __instanceXZ.y = z;
            }
            
            return self;
        }
        
        SetHeight = function(_height = height)
        {
            height = _height;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_yscale = BONK_MASK_SIZE / height;
            }
        
            return self;
        }
        
        GetAABB = function()
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
        
        SetRadius = function(_radius = radius)
        {
            radius = _radius;
            
            image_xscale = BONK_MASK_SIZE / (2*radius);
            image_yscale = BONK_MASK_SIZE / (2*radius);
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = BONK_MASK_SIZE / (2*radius);
            }
            
            return self;
        }
        
        Draw = function(_color = undefined, _wireframe = undefined)
        {
            __BONK_VERIFY_UGG
            UggCapsule(x, y, z - height/2, height, radius, _color, _wireframe);
        }
        
        
        
        return self;
    }
}