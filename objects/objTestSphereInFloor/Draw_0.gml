UggSetWireframe(true);
floor_.Draw();
UggSetWireframe(false);

sphereA.Draw(BonkSphereInFloor(sphereA, floor_)? c_red : c_lime);
sphereB.Draw(BonkSphereInFloor(sphereB, floor_)? c_red : c_lime);