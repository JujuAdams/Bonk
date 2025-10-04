// Feather disable all

with(oTestMesh)
{
    //BonkCreateFromVertexBuffers(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix, oTestInstanceParent);
    
    other.world = BonkCreateWorld(32, 32, 100, oTestInstanceParent);
    other.world.AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);
}