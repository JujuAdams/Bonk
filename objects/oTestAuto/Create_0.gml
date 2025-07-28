var _func = function(_x, _y)
{
    return instance_exists(instance_position(x+32 + 64*_x, y+32 + 64*_y, oTestAABB));
}

shape  = undefined;
shapeB = undefined;

var _collisionTL = false;
var _collisionT  = false;
var _collisionTR = false;
var _collisionL  = false;
var _collisionR  = false;
var _collisionBL = false;
var _collisionB  = false;
var _collisionBR = false;

if (_func(-1, -1))
{
    _collisionTL = true;
}

if (_func(0, -1))
{
    _collisionTL = true;
    _collisionT  = true;
    _collisionTR = true;
}

if (_func(1, -1))
{
    _collisionTR = true;
}

if (_func(-1, 0))
{
    _collisionTL = true;
    _collisionL  = true;
    _collisionBL = true;
}

if (_func(1, 0))
{
    _collisionTR = true;
    _collisionR  = true;
    _collisionBR = true;
}

if (_func(-1, 1))
{
    _collisionBL = true;
}

if (_func(0, 1))
{
    _collisionBL = true;
    _collisionB  = true;
    _collisionBR = true;
}

if (_func(1, 1))
{
    _collisionBR = true;
}

if (_collisionTL)
{
    if (_collisionTR)
    {
        if (_collisionBL)
        {
            if (_collisionBR)
            {
                shape = new BonkQuad(x, y, 32,   x+64, y, 32,   x, y+64, 32);
            }
            else
            {
                shape  = new BonkTriangle(x, y, 32,   x+64, y, 32,   x, y+64, 32);
                shapeB = new BonkTriangle(x, y+64, 32,   x+64, y, 32,   x+64, y+64, 0);
            }
        }
        else
        {
            if (_collisionBR)
            {
                shape  = new BonkTriangle(x, y, 32,   x+64, y, 32,   x+64, y+64, 32);
                shapeB = new BonkTriangle(x, y, 32,   x+64, y+64, 32,   x, y+64, 0);
            }
            else
            {
                shape = new BonkQuad(x, y, 32,   x+64, y, 32,   x, y+64, 0);
            }
        }
    }
    else
    {
        if (_collisionBL)
        {
            if (_collisionBR)
            {
                shape  = new BonkTriangle(x, y, 32,   x+64, y+64, 32,   x, y+64, 32);
                shapeB = new BonkTriangle(x, y, 32,   x+64, y, 0,    x+64, y+64, 32);
            }
            else
            {
                shape = new BonkQuad(x, y, 32,   x+64, y, 0,   x, y+64, 32);
            }
        }
        else
        {
            if (_collisionBR)
            {
                shape  = new BonkTriangle(x, y, 32,   x+64, y, 0,   x, y+64, 0);
                shapeB = new BonkTriangle(x, y+64, 0,   x+64, y, 0,   x+64, y+64, 32);
            }
            else
            {
                //Only top-left
                shape = new BonkTriangle(x, y, 32,   x+64, y, 0,   x, y+64, 0);
            }
        }
    }
}
else
{
    if (_collisionTR)
    {
        if (_collisionBL)
        {
            if (_collisionBR)
            {
                shape  = new BonkTriangle(x, y+64, 32,   x+64, y, 32,   x+64, y+64, 32);
                shapeB = new BonkTriangle(x, y, 0,   x+64, y, 32,   x, y+64, 32);
            }
            else
            {
                shape  = new BonkTriangle(x, y, 0,   x+64, y, 32,   x, y+64, 32);
                shapeB = new BonkTriangle(x+64, y, 32,   x+64, y+64, 0,   x, y+64, 32);
            }
        }
        else
        {
            if (_collisionBR)
            {
                shape = new BonkQuad(x, y, 0,   x+64, y, 32,   x, y+64, 0);
            }
            else
            {
                //Only top-right
                shape = new BonkTriangle(x, y, 0,   x+64, y, 32,   x+64, y+64, 0);
            }
        }
    }
    else
    {
        if (_collisionBL)
        {
            if (_collisionBR)
            {
                shape = new BonkQuad(x, y, 0,   x+64, y, 0,   x, y+64, 32);
            }
            else
            {
                //Only bottom-left
                shape = new BonkTriangle(x, y, 0,   x+64, y+64, 0,   x, y+64, 32);
            }
        }
        else
        {
            if (_collisionBR)
            {
                //Only bottom-right
                shape = new BonkTriangle(x, y+64, 0,   x+64, y, 0,   x+64, y+64, 32);
            }
            else
            {
                //Nothing around us!
                instance_destroy();
            }
        }
    }
}