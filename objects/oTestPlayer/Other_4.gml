with(oTestParent)
{
    other.world.Add(shape);
    
    if (variable_instance_get(self, "shapeB") != undefined)
    {
        other.world.Add(shapeB);
    }
}

with(oTestMesh)
{
    other.world.AddVertexBufferAsync(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}