UggSetWireframe(true);
aabb.Draw();
UggSetWireframe(false);

point.Draw(BonkPointInAABB(point, aabb)? c_red : c_lime);