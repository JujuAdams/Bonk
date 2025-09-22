// Feather disable all

line.Draw(c_aqua);

with(oTestPlayer)
{
    var _pointsArray = world.GetCellsFromShape(other.line);
    world.DrawCellsFromArray(_pointsArray);
}