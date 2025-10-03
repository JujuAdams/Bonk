UggSetWireframe(true);
cylinderA.Draw();
UggSetWireframe(false);

cylinderB.Draw(BonkCylinderTouchCylinder(cylinderA, cylinderB)? c_red : c_lime);
cylinderC.Draw(BonkCylinderTouchCylinder(cylinderA, cylinderC)? c_red : c_lime);