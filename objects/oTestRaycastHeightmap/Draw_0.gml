// Feather disable all

shape.DebugDraw();

raycast.DebugDraw(c_orange);
hit = raycast.Hit(shape);
if (hit.shape != undefined) UggSphere(hit.x, hit.y, hit.z, 3, c_red);

line.DebugDraw(c_yellow);
hit = line.Hit(shape);
if (hit.shape != undefined) UggSphere(hit.x, hit.y, hit.z, 3, c_red);

shape.DrawCellsFromArray(shape.GetCellsFromLine(line), c_blue);