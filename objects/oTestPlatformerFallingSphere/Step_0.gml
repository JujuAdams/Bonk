zSpeed -= 1;

var _steps = 1;
repeat(_steps)
{
    shape.x += xSpeed / _steps;
    shape.y += ySpeed / _steps;
    shape.z += zSpeed / _steps;
    
    with(oTestPlatformerFloor)
    {
        BonkCollision(other, other.shape, shape);
    }
    
    with(oTestPlatformerAABB)
    {
        BonkCollision(other, other.shape, shape);
    }
    
    with(oTestPlatformerCylinder)
    {
        BonkCollision(other, other.shape, shape);
    }
    
    with(oTestPlatformerSphere)
    {
        BonkCollision(other, other.shape, shape);
    }
    
    with(oTestPlatformerQuad)
    {
        BonkCollision(other, other.shape, shape);
    }
    
    with(oTestPlatformerTriangle)
    {
        BonkCollision(other, other.shape, shape);
    }
}