function __BonkClassCollideArrayContainer() constructor
{
    __collideArray = array_create_ext(BONK_INTERNAL_MAX_DEFLECT_COLLISIONS, function()
    {
        return new BonkResultCollide();
    });
    
    __count = 0;
}