capsule.Draw(c_white, true);

pointA.Draw(pointA.Touch(capsule)? c_red : c_lime);
pointB.Draw(pointB.Touch(capsule)? c_red : c_lime);