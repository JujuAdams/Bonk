zSpeed -= 1;

var _steps = 1;
repeat(_steps)
{
    primitive.x += xSpeed / _steps;
    primitive.y += ySpeed / _steps;
    primitive.z += zSpeed / _steps;
    
    with(oTestPlatformerFloor)
    {
        BonkCollision(other, other.primitive, primitive);
    }
    
    with(oTestPlatformerAABB)
    {
        BonkCollision(other, other.primitive, primitive);
    }
    
    with(oTestPlatformerCylinder)
    {
        BonkCollision(other, other.primitive, primitive);
    }
    
    with(oTestPlatformerSphere)
    {
        BonkCollision(other, other.primitive, primitive);
    }
}