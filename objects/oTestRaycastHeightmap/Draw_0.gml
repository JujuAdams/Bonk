// Feather disable all

shape.DebugDraw();
line.DebugDraw(c_yellow);

hit = line.Hit(shape);
if (hit.shape != undefined)
{
    UggSphere(hit.x, hit.y, hit.z, 3, c_red);
}

shape.DrawCellsFromArray(shape.GetCellsFromLine(line), c_blue);