capsule.Draw(c_white, true);

pointA.Draw(pointA.Inside(capsule)? c_red : c_lime);
pointB.Draw(pointB.Inside(capsule)? c_red : c_lime);