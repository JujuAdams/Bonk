// Feather disable all

/// @param x
/// @param y
/// @param z
/// @param radius
/// @param [groupVector=BONK_DEFAULT_GROUP]

//Set up statics
with(static_get(BonkStructSphere))
{
    __BonkCommonSphere();
}

function BonkStructSphere(_x, _y, _z, _radius, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
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
            zMin: z - radius,
            xMax: x + radius,
            yMax: y + radius,
            zMax: z + radius,
        };
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggSphere(x, y, z, radius, _color, _wireframe);
    }
}