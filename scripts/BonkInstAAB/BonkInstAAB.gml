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
/// @param radius
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstAAB(_x, _y, _z, _xSize, _ySize, _zSize, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(_x, _y, 0, _objectXY))
    {
        bonkType = BONK_TYPE_SPHERE;
        lineHitFunction = BonkLineHitSphere;
        
        static _collideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkSphereCollideAAB;
            _array[@ BONK_TYPE_OBB     ] = BonkSphereCollideRotatedBox;
            _array[@ BONK_TYPE_CAPSULE ] = BonkSphereCollideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkSphereCollideCylinder;
            _array[@ BONK_TYPE_QUAD    ] = BonkSphereCollideQuad;
            _array[@ BONK_TYPE_SPHERE  ] = BonkSphereCollideSphere;
            _array[@ BONK_TYPE_TRIANGLE] = BonkSphereCollideTriangle;
            return _array;
        })();
        
        static _insideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkSphereInsideAAB;
            _array[@ BONK_TYPE_OBB     ] = BonkSphereInsideRotatedBox;
            _array[@ BONK_TYPE_CAPSULE ] = BonkSphereInsideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkSphereInsideCylinder;
            _array[@ BONK_TYPE_QUAD    ] = BonkSphereInsideQuad;
            _array[@ BONK_TYPE_SPHERE  ] = BonkSphereInsideSphere;
            _array[@ BONK_TYPE_TRIANGLE] = BonkSphereInsideTriangle;
            return _array;
        })();
        
        __collideFuncLookup = _collideFuncLookup;
        __insideFuncLookup  = _insideFuncLookup;
        
        
        
        z = _z;
        
        xSize = _xSize;
        ySize = _ySize;
        zSize = _zSize;
        
        
        
        sprite_index = BonkMaskAAB;
        image_xscale = BONK_MASK_SIZE / _xSize;
        image_yscale = BONK_MASK_SIZE / _ySize;
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                sprite_index = BonkMaskAAB;
                image_xscale = BONK_MASK_SIZE / _xSize;
                image_yscale = BONK_MASK_SIZE / _zSize;
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
        
        SetSize = function(_x = xSize, _y = ySize, _z = zSize)
        {
            xSize = _x;
            ySize = _y;
            zSize = _z;
            
            image_xscale = BONK_MASK_SIZE / xSize;
            image_yscale = BONK_MASK_SIZE / ySize;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = BONK_MASK_SIZE / xSize;
                __instanceXZ.image_yscale = BONK_MASK_SIZE / zSize;
            }
        
            return self;
        }
        
        GetAABB = function()
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
        
        Draw = function(_color = undefined, _wireframe = undefined)
        {
            __BONK_VERIFY_UGG
            UggAABB(x, y, z, xSize, ySize, zSize, _color, _wireframe);
        }
        
        
        
        return self;
    }
}