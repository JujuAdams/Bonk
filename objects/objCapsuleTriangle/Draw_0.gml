var _result = capsule.Collision(triangle);
capsule.DebugDraw(_result.GetCollided()? c_red : c_lime);
triangle.DebugDraw(c_yellow);

//var _collide = BonkCapsuleTriangleIntersection(capsule.x1, capsule.y1, capsule.z1,
//                                               capsule.x2, capsule.y2, capsule.z2,
//                                               capsule.radius,
//                                               triangle.x1, triangle.y1, triangle.z1,
//                                               triangle.x2, triangle.y2, triangle.z2,
//                                               triangle.x3, triangle.y3, triangle.z3);