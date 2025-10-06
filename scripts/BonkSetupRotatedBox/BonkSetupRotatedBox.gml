// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the rotated box type.
/// 
/// In general, setting up an instance to work with Bonk will do the following things:
/// 
///  1. Set the following native GameMaker variables:
///     `x`  `y`  `mask_index`  `image_xscale`  `image_yscale`  `image_angle`  (and maybe `depth`)
/// 
///  2. Set variables that Bonk needs to operate
///     `z`  `bonkType`  `bonkGroup`  `__bonkCollideFuncLookup`  `__bonkTouchFuncLookup`
///     (and maybe `bonkCreateCallstack`)
/// 
///  3. Set variables to Bonk methods
///     `SetPosition()`  `AddPosition()`  `Touch()`  `Collide()`  `Deflect()`  `LineHit()`
///     `FilterTest()`  `DebugDraw()`  `DebugDrawMask()`
/// 
///  4. Set a handful of further variables and methods for the specific shape type
/// 
/// You can read about the how to use the shared general variables and methods in the
/// `Bonk Instance Details` Note asset found in the same asset browset folder as this function. The
/// following variables and methods are unique to this type of shape:
/// 
/// `.xSize` `.ySize` `.zSize`
///   **Read-only** variables that store the size of the box in each axis. You may read these at
///   any time but they must not be directly written. Please use the method below to change the
///   size of the box.
/// 
/// `.SetSize([x], [y], [z])`
///   Method to set the size of the box. If a parameter is set to `undefined` then the existing
///   size in that axis will be used.
/// 
/// `.zRotation`
///   **Read-only** variable that stores the rotation of the box in the z-axis. You may read this
///   variable at any time but it must not be directly written to. Please use the method below to
///   change the rotation of the box.
/// 
/// `.SetRotation([rotation])`
///   Method to set the rotation of the box in the z-axis. If a parameter is set to `undefined`
///   then the existing rotation in that axis will be used.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonInstanceFunctions(_groupVector);
    __BonkCommonRotatedBox();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    if (BONK_SET_INSTANCE_DEPTH)
    {
        depth = _z;
    }
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    zRotation = _zRotation;
    
    mask_index = __BonkMaskRotatedBox;
    image_xscale = _xSize / BONK_MASK_SIZE;
    image_yscale = _ySize / BONK_MASK_SIZE;
    image_angle  = _zRotation;
    
    
        
    SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        image_xscale = xSize / BONK_MASK_SIZE;
        image_yscale = ySize / BONK_MASK_SIZE;
        
        return self;
    }
    
    SetRotation = function(_zRotation = zRotation)
    {
        zRotation = _zRotation;
        
        image_angle = _zRotation;
        
        return self;
    }
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: z - 0.5*zSize,
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: z + 0.5*zSize,
        };
    }
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z, xSize, ySize, zSize, zRotation, _color, _wireframe);
    }
}