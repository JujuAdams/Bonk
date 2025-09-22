shape.Draw(c_lime, true);
line.Draw(c_yellow);

var _hit = line.Hit(world);
if (_hit.collision)
{
    UggSphere(_hit.x, _hit.y, _hit.z, 3, c_red);
}

var _aabb = shape.GetAABB();
world.DrawRangeVoxels(_aabb);

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
world.DrawRangeShapes(_aabb, c_red, true);
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);