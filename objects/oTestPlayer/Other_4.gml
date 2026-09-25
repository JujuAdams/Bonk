with(oTestParent)
{
    other.world.AddShape(shape);
    
    if (variable_instance_get(self, "shapeB") != undefined)
    {
        other.world.AddShape(shapeB);
    }
}

with(oTestBigModel)
{
    other.world.AddVertexBufferAsync(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}