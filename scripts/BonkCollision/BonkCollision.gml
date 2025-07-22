// Feather disable all

/// @param speedContainer
/// @param primitive
/// @param otherPrimitive

function BonkCollision(_speedContainer, _primitive, _otherPrimitive)
{
    var _reaction = _primitive.Collide(_otherPrimitive);
    if (_reaction.collision)
    {
        with(_primitive)
        {
            x += _reaction.dX;
            y += _reaction.dY;
            z += _reaction.dZ;
        }
        
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