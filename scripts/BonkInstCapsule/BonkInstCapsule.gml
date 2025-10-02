// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstCapsule(_x, _y, _z, _height, _radius, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(_x, _y, 0, _objectXY))
    {
        bonkType = BONK_TYPE_CAPSULE;
        __lineHitFunction = BonkLineHitCapsule;
        
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
        image_xscale = 2*_radius / BONK_MASK_SIZE;
        image_yscale = 2*_radius / BONK_MASK_SIZE;
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                sprite_index = BonkMaskAAB;
                image_xscale = other.image_xscale;
                image_yscale = _height / BONK_MASK_SIZE;
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
                __instanceXZ.image_yscale = height / BONK_MASK_SIZE;
            }
        
            return self;
        }
        
        GetAABB = function()
        {
            return {
                xMin: bbox_left,
                yMin: bbox_top,
                zMin: z - 0.5*height,
                xMax: bbox_right,
                yMax: bbox_bottom,
                zMax: z + 0.5*height,
            };
        }
        
        SetRadius = function(_radius = radius)
        {
            radius = _radius;
            
            image_xscale = 2*radius / BONK_MASK_SIZE;
            image_yscale = 2*radius / BONK_MASK_SIZE;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = image_xscale;
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