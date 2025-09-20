// Feather disable all

function __BonkClassPushOutReaction() constructor
{
    targetShape       = undefined;
    collisionReaction = undefined;
    pushOutType       = BONK_PUSH_OUT_NONE;
    
    static Clone = function()
    {
        var _new = new __BonkClassPushOutReaction();
        
        _new.targetShape       = targetShape;
        _new.collisionReaction = variable_clone(collisionReaction);
        _new.pushOutType       = pushOutType;
         
        return _new;
    }
}