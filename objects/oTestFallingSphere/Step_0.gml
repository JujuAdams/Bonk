var _x = shape.x;
var _y = shape.y;
var _z = shape.z;

zSpeed -= 1;

shape.x += xSpeed;
shape.y += ySpeed;
shape.z += zSpeed;

with(oTestFloor)
{
    BonkCollideAndRespond(other.shape, shape);
}

with(oTestAABB)
{
    BonkCollideAndRespond(other.shape, shape);
}

with(oTestAuto)
{
    BonkCollideAndRespond(other.shape, shape);
}

with(oTestCylinder)
{
    BonkCollideAndRespond(other.shape, shape);
}

with(oTestSphere)
{
    BonkCollideAndRespond(other.shape, shape);
}

with(oTestQuad)
{
    BonkCollideAndRespond(other.shape, shape);
}

with(oTestTriangle)
{
    BonkCollideAndRespond(other.shape, shape);
}

xSpeed = shape.x - _x;
ySpeed = shape.y - _y;
zSpeed = shape.z - _z;