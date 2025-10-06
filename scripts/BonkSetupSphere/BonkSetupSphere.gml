// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the sphere type.
/// 
/// In general, setting up an instance to work with Bonk will do the following things:
/// 
///  1. Set the following native GameMaker variables:
///     `x`  `y`  `mask_index`  `image_xscale`  `image_yscale`  `image_angle`  (and maybe `depth`)
/// 
///  2. Set variables that Bonk needs to operate:
///     `z`  `bonkType`  `bonkGroup`  `__bonkCollideFuncLookup`  `__bonkTouchFuncLookup`
///     (and maybe `bonkCreateCallstack`)
/// 
///  3. Set variables to Bonk methods:
///     `SetPosition()`  `AddPosition()`  `Touch()`  `Collide()`  `Deflect()`  `LineHit()`
///     `FilterTest()`  `DebugDraw()`  `DebugDrawMask()`
/// 
///  4. Set a handful of further variables and methods for the specific shape type
/// 
/// You can read about the how to use the shared general variables and methods in the
/// `Bonk Instance Details` Note asset. The following variables and methods are unique to this type
/// of shape:
/// 
/// `.radius`
///   **Read-only** variables that stores the radius of the sphere. You may read this variable at
///   any time but it must not be directly written to. Please use the method below to change the
///   radius of the sphere.
/// 
/// `.SetRadius([radius])`
///   Method to set the radius of the sphere. If the parameter is set to `undefined` then the
///   existing radius will be used.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param radius
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupSphere(_x, _y, _z, _radius, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonInstanceFunctions(_groupVector);
    __BonkCommonSphere();
    
    
    x = _x;
    y = _y;
    z = _z;
    
    radius = _radius;
    
    if (BONK_SET_INSTANCE_DEPTH)
    {
        depth = _z;
    }
    
    mask_index   = __BonkMaskCircle;
    image_xscale = 2*_radius / BONK_MASK_SIZE;
    image_yscale = 2*_radius / BONK_MASK_SIZE;
    image_angle  = 0;
    
    
    
    SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        image_xscale = 2*radius / BONK_MASK_SIZE;
        image_yscale = 2*radius / BONK_MASK_SIZE;
        
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
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggSphere(x, y, z, radius, _color, _wireframe);
    }
}