// Feather disable all

with(oTestMesh)
{
    other.world = BonkCreateWorld(20, 20, 20, oTestInstanceParent);
    other.world.AddVertexBufferAsync(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}