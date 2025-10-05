cylinder.DebugDraw(c_white, true);

pointA.DebugDraw(pointA.Touch(cylinder)? c_red : c_lime);
pointB.DebugDraw(pointB.Touch(cylinder)? c_red : c_lime);