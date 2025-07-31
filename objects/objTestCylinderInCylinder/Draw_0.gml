UggSetWireframe(true);
cylinderA.Draw();
UggSetWireframe(false);

cylinderB.Draw(BonkCylinderInsideCylinder(cylinderA, cylinderB)? c_red : c_lime);
cylinderC.Draw(BonkCylinderInsideCylinder(cylinderA, cylinderC)? c_red : c_lime);