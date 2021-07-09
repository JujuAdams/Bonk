/// @param collided
/// @param [normalX]
/// @param [normalY]
/// @param [normalZ]
/// @param [depth]



function BonkResult(_collided, _normalX, _normalY, _normalZ, _depth) constructor
{
    collided = _collided;
    
    normalX = _normalX;
    normalY = _normalY;
    normalZ = _normalZ;
    
    depth = _depth;
    
    x = undefined;
    y = undefined;
    z = undefined;
    
    
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR, _thickness = BONK_DRAW_RAY_THICKNESS)
    {
        if (collided && (x != undefined) && (y != undefined) && (z != undefined))
        {
            BonkDebugDrawRay(x, y, z, BONK_DRAW_RESULT_NORMAL_LENGTH*normalX + x, BONK_DRAW_RESULT_NORMAL_LENGTH*normalY + y, BONK_DRAW_RESULT_NORMAL_LENGTH*normalZ + z, _color, _thickness);
        }
    }
    
    static toString = function()
    {
        if (collided)
        {
            if ((x != undefined) && (y != undefined) && (z != undefined))
            {
                return "collision @ " + string(x) + "," + string(y) + "," + string(z) + ", normal=" + string(normalX) + "," + string(normalY) + "," + string(normalZ) + ", depth=" + string(depth);
            }
            else
            {
                return "collision, normal=" + string(normalX) + "," + string(normalY) + "," + string(normalZ) + ", depth=" + string(depth);
            }
        }
        else
        {
            return "no collision";
        }
    }
    
    
    
    static GetCollided = function()
    {
        return collided;
    }
    
    
    
    static __Invert = function()
    {
        normalX *= -1;
        normalY *= -1;
        normalZ *= -1;
        
        return self;
    }
    
    static __SetPoint = function(_x, _y, _z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
}