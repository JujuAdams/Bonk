// Feather disable all

/// @param reaction
/// @param primitive
/// @param speedContainer

function BonkCollisionResponse(_reaction, _primitive, _speedContainer)
{
    if (_reaction.collision)
    {
        _primitive.x += _reaction.dX;
        _primitive.y += _reaction.dY;
        _primitive.z += _reaction.dZ;
        
        with(_speedContainer)
        {
            //TODO - Inline
            var _velocityProjection = BonkVecProjectOntoPlane(xSpeed, ySpeed, zSpeed, _reaction.dX, _reaction.dY, _reaction.dZ);
            xSpeed = _velocityProjection.x;
            ySpeed = _velocityProjection.y;
            zSpeed = _velocityProjection.z;
        }
    }
}