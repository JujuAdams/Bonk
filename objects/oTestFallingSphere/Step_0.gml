var _x = shape.x;
var _y = shape.y;
var _z = shape.z;

zSpeed -= 1;

shape.x += xSpeed;
shape.y += ySpeed;
shape.z += zSpeed;

with(oTestFloor)
{
    shape.Deflect(other.shape);
}

with(oTestAAB)
{
    shape.Deflect(other.shape);
}

with(oTestCylinder)
{
    shape.Deflect(other.shape);
}

with(oTestSphere)
{
    shape.Deflect(other.shape);
}

with(oTestQuad)
{
    shape.Deflect(other.shape);
}

with(oTestTriangle)
{
    shape.Deflect(other.shape);
}

xSpeed = shape.x - _x;
ySpeed = shape.y - _y;
zSpeed = shape.z - _z;