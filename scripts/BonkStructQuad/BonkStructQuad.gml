// Feather disable all

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
with(static_get(BonkStructQuad))
{
    __BonkCommonQuad();
}

function BonkStructQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
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
        dX12 = x2 - x1;
        dY12 = y2 - y1;
        dZ12 = z2 - z1;
        
        dX31 = x1 - x3;
        dY31 = y1 - y3;
        dZ31 = z1 - z3;
        
        dX24 = -dX31;
        dY24 = -dY31;
        dZ24 = -dZ31;
        
        dX43 = -dX12;
        dY43 = -dY12;
        dZ43 = -dZ12;
        
        x4 = x2 + dX24;
        y4 = y2 + dY24;
        z4 = z2 + dZ24;
        
        lengthSqr12 = dX12*dX12 + dY12*dY12 + dZ12*dZ12;
        lengthSqr31 = dX31*dX31 + dY31*dY31 + dZ31*dZ31;
        lengthSqr24 = lengthSqr31;
        lengthSqr43 = lengthSqr12;
        
        normalX = dZ12*dY31 - dY12*dZ31;
        normalY = dX12*dZ31 - dZ12*dX31;
        normalZ = dY12*dX31 - dX12*dY31;
        
        var _length = sqrt(normalX*normalX + normalY*normalY + normalZ*normalZ);
        if (_length > 0)
        {
            var _coeff = 1 / _length;
            normalX *= _coeff;
            normalY *= _coeff;
            normalZ *= _coeff;
        }
    }
    
    static GetAABB = function()
    {
        return {
            xMin: min(x1, x2, x3, x4),
            yMin: min(y1, y2, y3, y4),
            zMin: min(z1, z2, z3, z4),
            xMax: max(x1, x2, x3, x4),
            yMax: max(y1, y2, y3, y4),
            zMax: max(z1, z2, z3, z4),
        };
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
}