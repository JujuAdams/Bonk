// Feather disable all

size = 500;

quadLeft   = new BonkStructAAB(-0.5*size,         0,         0,    10, size, size);
quadTop    = new BonkStructAAB(        0, -0.5*size,         0,    size, 10, size);
quadBelow  = new BonkStructAAB(        0,         0, -0.5*size,    size, size, 10);
quadRight  = new BonkStructAAB( 0.5*size,         0,         0,    10, size, size);
quadBottom = new BonkStructAAB(        0,  0.5*size,         0,    size, 10, size);
quadAbove  = new BonkStructAAB(        0,         0,  0.5*size,    size, size, 10);

sphereArray = array_create_ext(100, function()
{
    var _sphere = new BonkStructSphere(0, 0, 0,   20);
    
    var _vector = D3RandomVector();
    with(_sphere)
    {
        xSpeed = 4*_vector.x;
        ySpeed = 4*_vector.y;
        zSpeed = 4*_vector.z;
    }
    
    return _sphere;
});