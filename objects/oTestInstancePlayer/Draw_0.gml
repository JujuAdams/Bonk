shape.Draw(c_lime, true);
line.Draw(c_yellow);

var _hit = line.HitFirstInstance(oTestInstanceParent);
if (_hit.collision)
{
    UggSphere(_hit.x, _hit.y, _hit.z, 3, c_red);
}

//var _aabb = shape.GetAABB();
//world.DrawCellsFromRange(_aabb);
//world.DrawAABB();
//
//gpu_set_ztestenable(false);
//gpu_set_zwriteenable(false);
//world.DrawShapesFromRange(_aabb, c_red, true);
//gpu_set_ztestenable(true);
//gpu_set_zwriteenable(true);