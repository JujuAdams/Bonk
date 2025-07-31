with(oTestParent)
{
    other.world.Add(shape);
    
    if (variable_instance_get(self, "shapeB") != undefined)
    {
        other.world.Add(shapeB);
    }
}