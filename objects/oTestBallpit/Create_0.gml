// Feather disable all

size = 500;

quadLeft   = new BonkConstrAAB(-0.5*size,         0,         0,    10, size, size);
quadTop    = new BonkConstrAAB(        0, -0.5*size,         0,    size, 10, size);
quadBelow  = new BonkConstrAAB(        0,         0, -0.5*size,    size, size, 10);
quadRight  = new BonkConstrAAB( 0.5*size,         0,         0,    10, size, size);
quadBottom = new BonkConstrAAB(        0,  0.5*size,         0,    size, 10, size);
quadAbove  = new BonkConstrAAB(        0,         0,  0.5*size,    size, size, 10);

sphereArray = array_create_ext(50, function()
{
    var _sphere = new BonkConstrSphere(0, 0, 0,   20);
    
    var _vector = D3RandomVector();
    with(_sphere)
    {
        xSpeed = 4*_vector.x;
        ySpeed = 4*_vector.y;
        zSpeed = 4*_vector.z;
    }
    
    return _sphere;
});