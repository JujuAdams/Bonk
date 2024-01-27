UggSetWireframe(true);
floor_.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkAABBInFloor(aabbA, floor_)? c_red : c_lime);
aabbB.Draw(BonkAABBInFloor(aabbB, floor_)? c_red : c_lime);