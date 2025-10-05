capsule.DebugDraw(c_white, true);

pointA.DebugDraw(pointA.Touch(capsule)? c_red : c_lime);
pointB.DebugDraw(pointB.Touch(capsule)? c_red : c_lime);