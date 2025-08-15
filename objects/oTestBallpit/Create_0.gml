// Feather disable all

size = 500;

quadLeft   = new BonkAAB(-0.5*size,         0,         0,    10, size, size);
quadTop    = new BonkAAB(        0, -0.5*size,         0,    size, 10, size);
quadBelow  = new BonkAAB(        0,         0, -0.5*size,    size, size, 10);
quadRight  = new BonkAAB( 0.5*size,         0,         0,    10, size, size);
quadBottom = new BonkAAB(        0,  0.5*size,         0,    size, 10, size);
quadAbove  = new BonkAAB(        0,         0,  0.5*size,    size, size, 10);

sphereArray = array_create_ext(50, function()
{
    var _sphere = new BonkSphere(0, 0, 0,   20);
    
    var _vector = __BonkRandomVector();
    with(_sphere)
    {
        xSpeed = 4*_vector.x;
        ySpeed = 4*_vector.y;
        zSpeed = 4*_vector.z;
    }
    
    return _sphere;
});