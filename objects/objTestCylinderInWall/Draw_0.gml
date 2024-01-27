UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkCylinderInWall(cylinderA, wall)? c_red : c_lime);
cylinderB.Draw(BonkCylinderInWall(cylinderB, wall)? c_red : c_lime);