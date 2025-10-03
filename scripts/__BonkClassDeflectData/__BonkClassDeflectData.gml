// Feather disable all

function __BonkClassDeflectData() constructor
{
    targetShape       = undefined;
    collisionData = undefined;
    pushOutType       = BONK_PUSH_OUT_NONE;
    
    static Clone = function()
    {
        var _new = new __BonkClassDeflectData();
        
        _new.targetShape       = targetShape;
        _new.collisionData = variable_clone(collisionData);
        _new.pushOutType       = pushOutType;
         
        return _new;
    }
}