// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [groupVector=BONK_DEFAULT_GROUP]

//Set up statics
with(static_get(BonkStructRotatedBox))
{
    __BonkCommonRotatedBox();
}

function BonkStructRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    zRotation = _zRotation;
    
    
    
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
    
    static SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        return self;
    }
    
    static SetRotation = function(_zRotation = zRotation)
    {
        zRotation = _zRotation;
        
        return self;
    }
    
    static GetAABB = function()
    {
        //TODO - Do this properly
        return {
            xMin: x - sqrt(2)*max(xSize, ySize),
            yMin: y - sqrt(2)*max(xSize, ySize),
            zMin: z - 0.5*zSize,
            xMax: x + sqrt(2)*max(xSize, ySize),
            yMax: y + sqrt(2)*max(xSize, ySize),
            zMax: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z,   xSize, ySize, zSize,  zRotation,   _color, _wireframe);
    }
}