// Feather disable all

function Autoslope(_weight)
{
    height = 32;

    shape  = undefined;
    shapeB = undefined;

    var _func = function(_x, _y)
    {
        if (instance_exists(instance_position(x+32 + 64*_x, y+32 + 64*_y, oTestAAB))) return 1;
        if (instance_exists(instance_position(x+32 + 64*_x, y+32 + 64*_y, oTestAutoHeavy))) return 1/2;
    
        return 0;
    }

    var _collisionTL = _weight;
    var _collisionT  = _weight;
    var _collisionTR = _weight;
    var _collisionL  = _weight;
    var _collisionR  = _weight;
    var _collisionBL = _weight;
    var _collisionB  = _weight;
    var _collisionBR = _weight;



    _collisionTL += _func(-1, -1);

    var _value = _func(0, -1);
    _collisionTL += _value;
    _collisionT  += _value;
    _collisionTR += _value;

    _collisionTR += _func(1, -1);

    var _value = _func(-1, 0);
    _collisionTL += _value;
    _collisionL  += _value;
    _collisionBL += _value;

    var _value = _func(1, 0);
    _collisionTR += _value;
    _collisionR  += _value;
    _collisionBR += _value;

    _collisionBL += _func(-1, 1);

    var _value = _func(0, 1);
    _collisionBL += _value;
    _collisionB  += _value;
    _collisionBR += _value;

    _collisionBR += _func(1, 1);



    if (_collisionTL >= 1)
    {
        if (_collisionTR >= 1)
        {
            if (_collisionBL >= 1)
            {
                if (_collisionBR >= 1)
                {
                    shape = new BonkStructQuad(x, y, height,   x+64, y, height,   x, y+64, height);
                }
                else
                {
                    shape  = new BonkStructTriangle(x, y, height,   x+64, y, height,   x, y+64, height);
                    shapeB = new BonkStructTriangle(x, y+64, height,   x+64, y, height,   x+64, y+64, 0);
                }
            }
            else
            {
                if (_collisionBR >= 1)
                {
                    shape  = new BonkStructTriangle(x, y, height,   x+64, y, height,   x+64, y+64, height);
                    shapeB = new BonkStructTriangle(x, y, height,   x+64, y+64, height,   x, y+64, 0);
                }
                else
                {
                    shape = new BonkStructQuad(x, y, height,   x+64, y, height,   x, y+64, 0);
                }
            }
        }
        else
        {
            if (_collisionBL >= 1)
            {
                if (_collisionBR >= 1)
                {
                    shape  = new BonkStructTriangle(x, y, height,   x+64, y+64, height,   x, y+64, height);
                    shapeB = new BonkStructTriangle(x, y, height,   x+64, y, 0,    x+64, y+64, height);
                }
                else
                {
                    shape = new BonkStructQuad(x, y, height,   x+64, y, 0,   x, y+64, height);
                }
            }
            else
            {
                if (_collisionBR >= 1)
                {
                    shape  = new BonkStructTriangle(x, y, height,   x+64, y, 0,   x, y+64, 0);
                    shapeB = new BonkStructTriangle(x, y+64, 0,   x+64, y, 0,   x+64, y+64, height);
                }
                else
                {
                    //Only top-left
                    shape = new BonkStructTriangle(x, y, height,   x+64, y, 0,   x, y+64, 0);
                }
            }
        }
    }
    else
    {
        if (_collisionTR >= 1)
        {
            if (_collisionBL >= 1)
            {
                if (_collisionBR >= 1)
                {
                    shape  = new BonkStructTriangle(x, y+64, height,   x+64, y, height,   x+64, y+64, height);
                    shapeB = new BonkStructTriangle(x, y, 0,   x+64, y, height,   x, y+64, height);
                }
                else
                {
                    shape  = new BonkStructTriangle(x, y, 0,   x+64, y, height,   x, y+64, height);
                    shapeB = new BonkStructTriangle(x+64, y, height,   x+64, y+64, 0,   x, y+64, height);
                }
            }
            else
            {
                if (_collisionBR >= 1)
                {
                    shape = new BonkStructQuad(x, y, 0,   x+64, y, height,   x, y+64, 0);
                }
                else
                {
                    //Only top-right
                    shape = new BonkStructTriangle(x, y, 0,   x+64, y, height,   x+64, y+64, 0);
                }
            }
        }
        else
        {
            if (_collisionBL >= 1)
            {
                if (_collisionBR >= 1)
                {
                    shape = new BonkStructQuad(x, y, 0,   x+64, y, 0,   x, y+64, height);
                }
                else
                {
                    //Only bottom-left
                    shape = new BonkStructTriangle(x, y, 0,   x+64, y+64, 0,   x, y+64, height);
                }
            }
            else
            {
                if (_collisionBR >= 1)
                {
                    //Only bottom-right
                    shape = new BonkStructTriangle(x, y+64, 0,   x+64, y, 0,   x+64, y+64, height);
                }
                else
                {
                    //Nothing around us!
                    instance_destroy();
                }
            }
        }
    }
}