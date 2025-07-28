zSpeed -= 1;

shape.x += xSpeed;
shape.y += ySpeed;
shape.z += zSpeed;

with(oTestFloor)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestAABB)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestAuto)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestCylinder)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestSphere)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestQuad)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestTriangle)
{
    BonkCollideAndRespond(other.shape, shape, other);
}