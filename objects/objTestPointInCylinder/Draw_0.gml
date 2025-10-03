cylinder.Draw(c_white, true);

pointA.Draw(pointA.Touch(cylinder)? c_red : c_lime);
pointB.Draw(pointB.Touch(cylinder)? c_red : c_lime);