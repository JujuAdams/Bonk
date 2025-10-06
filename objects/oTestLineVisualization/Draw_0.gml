// Feather disable all

line.DebugDraw(c_aqua);

with(oTestPlayer)
{
    var _pointsArray = world.GetCellsFromLine(other.line);
    world.DrawCellsFromArray(_pointsArray);
}