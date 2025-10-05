// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [groupVector=BONK_DEFAULT_GROUP]

//Set up statics
with(static_get(BonkStructAAB))
{
    __BonkCommonAAB();
}

function BonkStructAAB(_x, _y, _z, _xSize, _ySize, _zSize, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    
    
    static __SetPositionFree = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static __SetPositionInWorld = function(_x = x, _y = y, _z = z)
    {
        __world.__MoveShape(_x - x, _y - y, _z - z, self);
        
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    SetPosition = __SetPositionFree;
    
    static RemoveFromWorld = function()
    {
        if (__world != undefined)
        {
            __world.__RemoveShape(self);
            SetPosition = __SetPositionFree;
        }
    }
    
    static SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x - 0.5*xSize,
            yMin: y - 0.5*ySize,
            zMin: z - 0.5*zSize,
            xMax: x + 0.5*xSize,
            yMax: y + 0.5*ySize,
            zMax: z + 0.5*zSize,
        };
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, xSize, ySize, zSize, _color, _wireframe);
    }
}