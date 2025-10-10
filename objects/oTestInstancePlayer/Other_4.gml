// Feather disable all

with(oTestMesh)
{
    other.world.AddVertexBufferAsync(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}