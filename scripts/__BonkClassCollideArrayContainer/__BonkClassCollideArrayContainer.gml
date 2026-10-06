function __BonkClassCollideArrayContainer() constructor
{
    __collideArray = array_create_ext(20, function()
    {
        return new BonkResultCollide();
    });
    
    __count = 0;
}