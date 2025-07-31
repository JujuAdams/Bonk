cylinder.Draw(c_white, true);

pointA.Draw(pointA.Inside(cylinder)? c_red : c_lime);
pointB.Draw(pointB.Inside(cylinder)? c_red : c_lime);