shape.Draw(undefined, true);

var _aabb = shape.GetAABB();
UggAABB(0.5*(_aabb.xMin + _aabb.xMax), 0.5*(_aabb.yMin + _aabb.yMax), 0.5*(_aabb.zMin + _aabb.zMax),
        _aabb.xMax - _aabb.xMin, _aabb.yMax - _aabb.yMin, _aabb.zMax - _aabb.zMin,
        c_aqua, true);

shape.DrawXY();