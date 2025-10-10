shape.DebugDraw(c_lime, true);
line.DebugDraw(c_yellow);

var _hit = line.Hit(world);
if (_hit.shape != undefined)
{
    UggSphere(_hit.x, _hit.y, _hit.z, 3, c_red);
}

world.DrawNeighborhoodForLine(line, c_red);