// Feather disable all

with(oTestMesh)
{
    other.world = BonkCreateWorld(32, 32, 100, oTestInstanceParent);
    other.world.AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}