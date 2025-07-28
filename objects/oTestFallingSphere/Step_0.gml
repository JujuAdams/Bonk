var _x = shape.x;
var _y = shape.y;
var _z = shape.z;

zSpeed -= 1;

shape.x += xSpeed;
shape.y += ySpeed;
shape.z += zSpeed;

with(oTestFloor)
{
    BonkPushOut(other.shape, shape);
}

with(oTestAABB)
{
    BonkPushOut(other.shape, shape);
}

with(oTestAuto)
{
    BonkPushOut(other.shape, shape);
}

with(oTestCylinder)
{
    BonkPushOut(other.shape, shape);
}

with(oTestSphere)
{
    BonkPushOut(other.shape, shape);
}

with(oTestQuad)
{
    BonkPushOut(other.shape, shape);
}

with(oTestTriangle)
{
    BonkPushOut(other.shape, shape);
}

xSpeed = shape.x - _x;
ySpeed = shape.y - _y;
zSpeed = shape.z - _z;