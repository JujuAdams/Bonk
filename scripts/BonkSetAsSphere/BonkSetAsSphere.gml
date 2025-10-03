// Feather disable all

/// @param instance
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param radius
/// @param [objectXZ]

function BonkSetAsSphere(_instance, _x, _y, _z, _radius, _objectXZ = BonkMaskXZ)
{
    with(_instance)
    {
        __BonkSetAsCommon();
        
        bonkType = BONK_TYPE_SPHERE;
        __lineHitFunction = BonkLineHitSphere;
        
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
        radius = _radius;
        
        
        
        sprite_index = __BonkMaskCircle;
        image_xscale = 2*_radius / BONK_MASK_SIZE;
        image_yscale = 2*_radius / BONK_MASK_SIZE;
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                sprite_index = __BonkMaskCircle;
                image_xscale = other.image_xscale;
                image_yscale = 2*_radius / BONK_MASK_SIZE;
            }
        }
        
        
        
        SetPosition = function(_x = x, _y = y, _z = z)
        {
            x = _x;
            y = _y;
            z = _z;
        
            return self;
        }
        
        SetRadius = function(_radius = radius)
        {
            radius = _radius;
            
            image_xscale = 2*radius / BONK_MASK_SIZE;
            image_yscale = 2*radius / BONK_MASK_SIZE;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = image_xscale;
                __instanceXZ.image_yscale = 2*radius / BONK_MASK_SIZE;
            }
            
            return self;
        }
        
        GetAABB = function()
        {
            return {
                xMin: bbox_left,
                yMin: bbox_top,
                zMin: z - radius,
                xMax: bbox_right,
                yMax: bbox_bottom,
                zMax: z + radius,
            };
        }
        
        Draw = function(_color = undefined, _wireframe = undefined)
        {
            __BONK_VERIFY_UGG
            UggSphere(x, y, z, radius, _color, _wireframe);
        }
        
        
        
        return self;
    }
}