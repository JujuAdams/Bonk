// Feather disable all

function __BonkClassDeflectData() constructor
{
    targetShape   = undefined;
    collisionData = undefined;
    deflectType   = BONK_DEFLECT_NONE;
    
    static Clone = function()
    {
        var _new = new __BonkClassDeflectData();
        
        _new.targetShape       = targetShape;
        _new.collisionData = variable_clone(collisionData);
        _new.deflectType       = deflectType;
         
        return _new;
    }
}