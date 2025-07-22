UggSetWireframe(true);
cylinderA.Draw();
UggSetWireframe(false);

cylinderB.Draw(BonkBoolCylinderInCylinder(cylinderA, cylinderB)? c_red : c_lime);
cylinderC.Draw(BonkBoolCylinderInCylinder(cylinderA, cylinderC)? c_red : c_lime);