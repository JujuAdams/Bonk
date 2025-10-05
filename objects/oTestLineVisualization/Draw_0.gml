// Feather disable all

line.DebugDraw(c_aqua);

with(oTestPlayer)
{
    var _pointsArray = world.GetCellsFromShape(other.line);
    world.DrawCellsFromArray(_pointsArray);
}