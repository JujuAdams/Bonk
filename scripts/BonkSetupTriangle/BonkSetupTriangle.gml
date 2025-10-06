// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the triangle type.
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
/// `.x` `.y` `.z`
///   These variables are **read-only** for this shape type and are derived by calculating the
///   centre of the triangle when calling `Refresh()`.
/// 
/// `.x1` `.y1` `.z1` `.x2` `.y2` `.z2` `.x3` `.y3` `.z3`
///   These variables store the coordinates of the vertices of the triangle. These variables may be
///   read at any time. You may also write to these variables; however, if you do change any of the
///   coordinates you must call `Refresh()` before the next collision check to ensure that the
///   underlying instance collision mask remains accurate.
/// 
/// `.Refresh()`
///   Updates various internal values and properties, including the following variables (some of
///   which are native GameMaker variables): `x` `y` `z` `image_xscale` `image_yscale` `normalX`
///   `normalY` `normalZ` (and maybe `depth`). You should call this method after changing any of
///   above triangle coordinates and before the next collision check.
/// 
/// `.normalX` `.normalY` `.normalZ`
///   **Read-only** variables that store the normal to the triangle. This value is calculated by
///   the `Refresh()` method. You may read these variables at any time but they must not be
///   directly written to.
/// 
/// `.__bonk*`
///   Various cached values that are used to speed up collision detection. These are **read-only**
///   and even then you'll probably never need to read these variables.
/// 
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3
/// @param [groupVector=BONK_DEFAULT_GROUP]


function BonkSetupTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonInstanceFunctions(_groupVector);
    __BonkCommonTriangle();
    
    
    
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    x3 = _x3;
    y3 = _y3;
    z3 = _z3;
    
    mask_index = __BonkMaskAAB;
    
    
    
    Refresh = function()
    {
        __bonkDX12 = x2 - x1;
        __bonkDY12 = y2 - y1;
        __bonkDZ12 = z2 - z1;
        
        __bonkDX23 = x3 - x2;
        __bonkDY23 = y3 - y2;
        __bonkDZ23 = z3 - z2;
        
        __bonkDX31 = x1 - x3;
        __bonkDY31 = y1 - y3;
        __bonkDZ31 = z1 - z3;
        
        __bonkLengthSqr12 = __bonkDX12*__bonkDX12 + __bonkDY12*__bonkDY12 + __bonkDZ12*__bonkDZ12;
        __bonkLengthSqr23 = __bonkDX23*__bonkDX23 + __bonkDY23*__bonkDY23 + __bonkDZ23*__bonkDZ23;
        __bonkLengthSqr31 = __bonkDX31*__bonkDX31 + __bonkDY31*__bonkDY31 + __bonkDZ31*__bonkDZ31;
        
        normalX = __bonkDZ12*__bonkDY31 - __bonkDY12*__bonkDZ31;
        normalY = __bonkDX12*__bonkDZ31 - __bonkDZ12*__bonkDX31;
        normalZ = __bonkDY12*__bonkDX31 - __bonkDX12*__bonkDY31;
        
        var _length = sqrt(normalX*normalX + normalY*normalY + normalZ*normalZ);
        if (_length > 0)
        {
            var _coeff = 1 / _length;
            normalX *= _coeff;
            normalY *= _coeff;
            normalZ *= _coeff;
        }
        
        var _minX = min(x1, x2, x3);
        var _maxX = max(x1, x2, x3);
        var _minY = min(y1, y2, y3);
        var _maxY = max(y1, y2, y3);
        var _minZ = min(z1, z2, z3);
        var _maxZ = max(z1, z2, z3);
        
        x = 0.5*(_minX + _maxX);
        y = 0.5*(_minY + _maxY);
        z = 0.5*(_minZ + _maxZ);
        
        if (BONK_SET_INSTANCE_DEPTH)
        {
            depth = z;
        }
        
        image_xscale = max(BONK_INSTANCE_MIN_SIZE, _maxX - _minX) / BONK_MASK_SIZE;
        image_yscale = max(BONK_INSTANCE_MIN_SIZE, _maxY - _minY) / BONK_MASK_SIZE;
    }
    
    Refresh();
    
    
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: min(z1, z2, z3),
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: max(z1, z2, z3),
        };
    }
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggTriangle(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
}