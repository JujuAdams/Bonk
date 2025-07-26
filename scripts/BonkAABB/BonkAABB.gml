// Feather disable all

/// Constructor that generates an axis-aligned bounding box. Such a box cannot be rotated.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Sphere
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize

function BonkAABB(_x, _y, _z, _xSize, _ySize, _zSize) : __BonkClassShared(_x, _y, _z) constructor
{
    static bonkType = BONK_TYPE_AABB;
    
    xHalfSize = 0.5*_xSize;
    yHalfSize = 0.5*_ySize;
    zHalfSize = 0.5*_zSize;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetSize = function(_x = 2*xHalfSize, _y = 2*yHalfSize, _z = 2*zHalfSize)
    {
        xHalfSize = 0.5*_x;
        yHalfSize = 0.5*_y;
        zHalfSize = 0.5*_z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            x1: x - xHalfSize,
            y1: y - yHalfSize,
            z1: z - zHalfSize,
            x2: x + xHalfSize,
            y2: y + yHalfSize,
            z2: z + zHalfSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, 2*xHalfSize, 2*yHalfSize, 2*zHalfSize, _color, _wireframe);
    }
}