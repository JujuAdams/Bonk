// Feather disable all

line.Draw(c_aqua);

with(oTestPlayer)
{
    var _pointsArray = world.GetShapeCells(other.line);
    world.DrawCellsVoxels(_pointsArray);
}