// Feather disable all

function __BonkClassDeflectData() constructor
{
    collisionData = new __BonkClassCollideData();
    deflectType   = BONK_DEFLECT_NONE;
    
    static __Null = function()
    {
        collisionData.__Null();
        deflectType = BONK_DEFLECT_NONE;
        
        return self;
    }
}