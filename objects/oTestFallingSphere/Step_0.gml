var _x = shape.x;
var _y = shape.y;
var _z = shape.z;

zSpeed -= 1;

shape.AddPosition(xSpeed, ySpeed, zSpeed);

with(oTestFloor)
{
    shape.PushOut(other.shape);
}

with(oTestAAB)
{
    shape.PushOut(other.shape);
}

with(oTestCylinder)
{
    shape.PushOut(other.shape);
}

with(oTestSphere)
{
    shape.PushOut(other.shape);
}

with(oTestQuad)
{
    shape.PushOut(other.shape);
}

with(oTestTriangle)
{
    shape.PushOut(other.shape);
}

xSpeed = shape.x - _x;
ySpeed = shape.y - _y;
zSpeed = shape.z - _z;