zSpeed -= 1;

shape.x += xSpeed;
shape.y += ySpeed;
shape.z += zSpeed;

with(oTestPlatformerFloor)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerAABB)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerCylinder)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerSphere)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerQuad)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerTriangle)
{
    BonkCollideAndRespond(other.shape, shape, other);
}