aabb.Draw(c_white, true);

point.Draw(point.Inside(aabb)? c_red : c_lime);