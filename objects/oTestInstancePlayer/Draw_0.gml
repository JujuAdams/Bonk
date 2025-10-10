DebugDraw(c_lime, true);
line.DebugDraw(c_yellow);

var _hit = line.HitFirst(oTestInstanceParent);
if (_hit.shape != undefined)
{
    UggSphere(_hit.x, _hit.y, _hit.z, 3, c_red);
}

//world.DrawNeighborhoodForShape(shape, c_red);