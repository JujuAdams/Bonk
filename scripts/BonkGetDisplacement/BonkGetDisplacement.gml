// Feather disable all

/// @param shape
/// @param otherShape

function BonkGetDisplacement(_shape, _otherShape)
{
    static _nullReaction = __Bonk().__nullReaction;
    
    with(_shape)
    {
        var _reaction = Collide(_otherShape);
        if (_reaction.collision)
        {
            x += _reaction.dX;
            y += _reaction.dY;
            z += _reaction.dZ;
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}