UggSetWireframe(true);
aabb.Draw();
UggSetWireframe(false);

point.Draw(BonkBoolPointInAABB(point, aabb)? c_red : c_lime);