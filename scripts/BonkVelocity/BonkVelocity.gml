// Feather disable all

/// @param [xSpeed=0]
/// @param [ySpeed=0]
/// @param [zSpeed=0]

function BonkVelocity(_xSpeed = 0, _ySpeed = 0, _zSpeed = 0) constructor
{
    xSpeed = _xSpeed;
    ySpeed = _ySpeed;
    zSpeed = _zSpeed;
    
    static GetSpeed = function()
    {
        return sqrt(xSpeed*xSpeed + ySpeed*ySpeed + zSpeed*zSpeed);
    }
    
    static Reset = function()
    {
        xSpeed = 0;
        ySpeed = 0;
        zSpeed = 0;
    }
}