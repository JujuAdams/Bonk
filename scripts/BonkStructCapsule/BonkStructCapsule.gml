// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [groupVector=BONK_DEFAULT_GROUP]

//Set up statics
with(static_get(BonkStructCapsule))
{
    __BonkCommonCapsule();
}

function BonkStructCapsule(_x, _y, _z, _height, _radius, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    radius = _radius;
    
    
    
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
    
    static SetHeight = function(_height = height)
    {
        height = _height;
        
        return self;
    }
    
    static SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x - radius,
            yMin: y - radius,
            zMin: z - 0.5*height,
            xMax: x + radius,
            yMax: y + radius,
            zMax: z + 0.5*height,
        };
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCapsule(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}