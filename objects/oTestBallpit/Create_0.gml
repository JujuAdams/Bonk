// Feather disable all

size = 400;

quadLeft   = new BonkAAB(-0.5*size,         0,         0,    10, size, size);
quadTop    = new BonkAAB(        0, -0.5*size,         0,    size, 10, size);
quadBelow  = new BonkAAB(        0,         0, -0.5*size,    size, size, 10);
quadRight  = new BonkAAB( 0.5*size,         0,         0,    10, size, size);
quadBottom = new BonkAAB(        0,  0.5*size,         0,    size, 10, size);
quadAbove  = new BonkAAB(        0,         0,  0.5*size,    size, size, 10);

sphereA = new BonkSphere(0, 0,  100,   20);
sphereB = new BonkSphere(0, 0, -100,   20);

var _vector = __BonkRandomVector();
with(sphereA)
{
    xSpeed = 0; //4*_vector.x;
    ySpeed = 0; //4*_vector.y;
    zSpeed = 0; //4*_vector.z;
}

var _vector = __BonkRandomVector();
with(sphereB)
{
    xSpeed = 0; //4*_vector.x;
    ySpeed = 0; //4*_vector.y;
    zSpeed = 2; //4*_vector.z;
}