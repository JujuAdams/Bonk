shape.Draw(c_lime, true);
line.Draw(c_yellow);

var _hit = line.Hit(world);
if (_hit.collision)
{
    UggSphere(_hit.x, _hit.y, _hit.z, 3, c_red);
}