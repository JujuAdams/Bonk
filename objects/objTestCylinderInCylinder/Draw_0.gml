UggSetWireframe(true);
cylinderA.Draw();
UggSetWireframe(false);

cylinderB.Draw(BonkCylinderInCylinder(cylinderA, cylinderB)? c_red : c_lime);
cylinderC.Draw(BonkCylinderInCylinder(cylinderA, cylinderC)? c_red : c_lime);