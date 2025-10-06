// Feather disable all

/// Sets the currently scoped instance as a Bonk instance that can be used to stored Bonk structs
/// in a spatial hash map. This is useful for storing static meshes generated from 3D models.
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
///   **Read-only** variables that store the size of the AAB in each axis. You may read these at
///   any time but they must not be directly written. Please use the method below to change the
///   size of the AAB.
/// 
/// `.SetSize([x], [y], [z])`
///   Method to set the size of the AAB. If a parameter is set to `undefined` then the existing
///   size in that axis will be used.
/// 
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkSetupWorld(_cellXSize, _cellYSize, _cellZSize)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    if (BONK_DEBUG_INSTANCES)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize);
    
    mask_index = __BonkMaskAAB;
    image_xscale = 0;
    image_yscale = 0;
    
    DebugDrawMask = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }
}