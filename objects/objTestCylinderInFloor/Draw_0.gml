UggSetWireframe(true);
floor_.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkCylinderInFloor(cylinderA, floor_)? c_red : c_lime);
cylinderB.Draw(BonkCylinderInFloor(cylinderB, floor_)? c_red : c_lime);