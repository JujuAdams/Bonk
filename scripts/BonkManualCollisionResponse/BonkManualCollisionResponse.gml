// Feather disable all

/// @param reaction
/// @param x
/// @param y
/// @param z
/// @param xSpeed
/// @param ySpeed
/// @param zSpeed

function BonkManualCollisionResponse(_reaction, _x, _y, _z, _xSpeed, _ySpeed, _zSpeed)
{
    static _result = {
        x: 0,
        y: 0,
        z: 0,
        xSpeed: 0,
        ySpeed: 0,
        zSpeed: 0,
    };
    
    if (_reaction.collision)
    {
        with(_result)
        {
            x = _x + _reaction.dX;
            y = _y + _reaction.dY;
            z = _z + _reaction.dZ;
            
            //TODO - Inline
            var _velocityProjection = BonkVecProjectOntoPlane(_xSpeed, _ySpeed, _zSpeed, _reaction.dX, _reaction.dY, _reaction.dZ);
            xSpeed = _velocityProjection.x;
            ySpeed = _velocityProjection.y;
            zSpeed = _velocityProjection.z;
        }
    }
    else
    {
        with(_result)
        {
            x = _x;
            y = _y;
            z = _z;
            
            xSpeed = _xSpeed;
            ySpeed = _ySpeed;
            zSpeed = _zSpeed;
        }
    }
    
    return _result;
}