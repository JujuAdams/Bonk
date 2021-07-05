/// @param normalX
/// @param normalY
/// @param normalZ
/// @param depth
/// @param [collisionX]
/// @param [collisionY]
/// @param [collisionZ]



function BonkResult(_normalX, _normalY, _normalZ, _depth, _x, _y, _z) constructor
{
    if ((_normalX == undefined) && (_normalY == undefined) && (_normalZ == undefined) && (_depth == undefined))
    {
        collided = false;
        
        normalX = 0;
        normalY = 0;
        normalZ = 0;
        
        depth = 0;
        
        x = undefined;
        y = undefined
        z = undefined;
    }
    else
    {
        collided = true;
        
        normalX = _normalX;
        normalY = _normalY;
        normalZ = _normalZ;
        
        depth = _depth;
        
        x = _x;
        y = _y;
        z = _z;
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
}