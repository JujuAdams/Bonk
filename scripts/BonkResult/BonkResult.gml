/// 
/// 
/// @param normalX
/// @param normalY
/// @param normalZ
/// @param depth
/// @param [collisionX]
/// @param [collisionY]
/// @param [collisionZ]



function BonkResult(_normalX, _normalY, _normalZ, _depth, _x, _y, _z) constructor
{
    if (_depth == undefined)
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