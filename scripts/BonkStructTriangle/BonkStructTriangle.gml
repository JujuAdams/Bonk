// Feather disable all

/// Constructor that creates a Bonk triangle as a struct rather than an instance. For further
/// information please refer to `BonkSetupTriangle()` (though native GameMaker variables other
/// than `x` and `y` will not be set for structs).
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

//Set up statics
with(static_get(BonkStructTriangle))
{
    __BonkCommonTriangle();
}

function BonkStructTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    x3 = _x3;
    y3 = _y3;
    z3 = _z3;
    
    Refresh();
    
    
    
    static __SetPositionFree = function() {}
    static __SetPositionInWorld = function() {}
    
    SetPosition = __SetPositionFree;
    
    static Refresh = function()
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
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggTriangle(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
    
    static GetAABB = function()
    {
        return {
            xMin: min(x1, x2, x3),
            yMin: min(y1, y2, y3),
            zMin: min(z1, z2, z3),
            xMax: max(x1, x2, x3),
            yMax: max(y1, y2, y3),
            zMax: max(z1, z2, z3),
        };
    }
}