UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkBoolCylinderInWall(cylinderA, wall)? c_red : c_lime);
cylinderB.Draw(BonkBoolCylinderInWall(cylinderB, wall)? c_red : c_lime);