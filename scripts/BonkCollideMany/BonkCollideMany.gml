// Feather disable all

/// @param shapeArray
/// @param subjectShape

function BonkCollideMany(_shapeArray, _subjectShape)
{
    static _nullCollisionReaction = __Bonk().__nullCollisionReaction;
    
    var _returnReaction = _nullCollisionReaction;
    var _largestDepth = 0;
    
    var _i = 0;
    repeat(array_length(_shapeArray))
    {
        var _reaction = _shapeArray[_i].Collide(_subjectShape);
        if (_reaction.collision)
        {
            with(_reaction.collisionReaction)
            {
                var _depth = dX*dX + dY*dY + dZ*dZ;
                if (_depth > _largestDepth)
                {
                    _largestDepth = _depth;
                    _returnReaction = _reaction.Clone();
                }
            }
        }
        
        ++_i;
    }
    
    return _returnReaction;
}