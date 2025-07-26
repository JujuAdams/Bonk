sphere.Draw(c_white, true);

point.Draw(point.Inside(sphere)? c_red : c_lime);