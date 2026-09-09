with(oTestParent)
{
    other.world.AddShape(shape);
    
    if (variable_instance_get(self, "shapeB") != undefined)
    {
        other.world.AddShape(shapeB);
    }
}

with(oTestMesh)
{
    other.world.AddVertexBufferAsync(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}

with(oTestHeightmapVolume)
{
    other.world.AddVertexBufferAsync(vbuffVolume, GetHeightmapVolumeVertexFormat());
}