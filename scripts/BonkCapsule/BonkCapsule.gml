// Feather disable all

/// Constructor that generates a z-aligned capsule.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - AABBs
/// - Cylinder / CylinderExt
/// - Capsule
/// - Sphere
/// - Quad
/// - Triangle
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius

function BonkCapsule(_x, _y, _z, _height, _radius) : __BonkClassShared(_x, _y, _z) constructor
{
    static bonkType = BONK_TYPE_CAPSULE;
    
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    radius = _radius;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
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
            x1: x - radius,
            y1: y - radius,
            z1: z - 0.5*height,
            x2: x + radius,
            y2: y + radius,
            z2: z + 0.5*height,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCapsule(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}