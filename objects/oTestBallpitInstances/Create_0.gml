// Feather disable all

size = 500;

quadLeft   = BonkCreateAAB(-0.5*size,         0,         0,    10, size, size);
quadTop    = BonkCreateAAB(        0, -0.5*size,         0,    size, 10, size);
quadBelow  = BonkCreateAAB(        0,         0, -0.5*size,    size, size, 10);
quadRight  = BonkCreateAAB( 0.5*size,         0,         0,    10, size, size);
quadBottom = BonkCreateAAB(        0,  0.5*size,         0,    size, 10, size);
quadAbove  = BonkCreateAAB(        0,         0,  0.5*size,    size, size, 10);

sphereArray = array_create_ext(100, function()
{
    var _sphere = BonkCreateSphere(0, 0, 0, 20, oBallpitSphere);
    
    var _vector = D3RandomVector();
    with(_sphere)
    {
        xSpeed = 4*_vector.x;
        ySpeed = 4*_vector.y;
        zSpeed = 4*_vector.z;
    }
    
    return _sphere;
});