// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the quad type.
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

function BonkSetupQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonFunctions(_groupVector);
    __BonkCommonQuad();
    
    
    
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
        
        __bonkDX31 = x1 - x3;
        __bonkDY31 = y1 - y3;
        __bonkDZ31 = z1 - z3;
        
        __bonkDX24 = -__bonkDX31;
        __bonkDY24 = -__bonkDY31;
        __bonkDZ24 = -__bonkDZ31;
        
        __bonkDX43 = -__bonkDX12;
        __bonkDY43 = -__bonkDY12;
        __bonkDZ43 = -__bonkDZ12;
        
        x4 = x2 + __bonkDX24;
        y4 = y2 + __bonkDY24;
        z4 = z2 + __bonkDZ24;
        
        __bonkLengthSqr12 = __bonkDX12*__bonkDX12 + __bonkDY12*__bonkDY12 + __bonkDZ12*__bonkDZ12;
        __bonkLengthSqr31 = __bonkDX31*__bonkDX31 + __bonkDY31*__bonkDY31 + __bonkDZ31*__bonkDZ31;
        __bonkLengthSqr24 = __bonkLengthSqr31;
        __bonkLengthSqr43 = __bonkLengthSqr12;
        
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
        
        var _minX = min(x1, x2, x3, x4);
        var _maxX = max(x1, x2, x3, x4);
        var _minY = min(y1, y2, y3, y4);
        var _maxY = max(y1, y2, y3, y4);
        var _minZ = min(z1, z2, z3, z4);
        var _maxZ = max(z1, z2, z3, z4);
        
        x = 0.5*(_minX + _maxX);
        y = 0.5*(_minY + _maxY);
        z = 0.5*(_minZ + _maxZ);
        
        if (BONK_SET_INSTANCE_DEPTH)
        {
            depth = -_z;
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
            zMin: min(z1, z2, z3, z4),
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: max(z1, z2, z3, z4),
        };
    }
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
}