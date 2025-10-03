// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstCylinder(_x, _y, _z, _height, _radius, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(_x, _y, 0, _objectXY))
    {
        bonkType = BONK_TYPE_CYLINDER;
        __lineHitFunction = BonkLineHitCylinder;
        
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
        
        __collideFuncLookup = _collideFuncLookup;
        __insideFuncLookup  = _insideFuncLookup;
        
        
        
        z = _z;
        
        height = _height;
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
                
                sprite_index = __BonkMaskAAB;
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
            UggCylinder(x, y, z - height/2, height, radius, _color, _wireframe);
        }
        
        
        
        return self;
    }
}