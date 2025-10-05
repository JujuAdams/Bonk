UggSetWireframe(true);
cylinderA.DebugDraw();
UggSetWireframe(false);

cylinderB.DebugDraw(BonkCylinderTouchCylinder(cylinderA, cylinderB)? c_red : c_lime);
cylinderC.DebugDraw(BonkCylinderTouchCylinder(cylinderA, cylinderC)? c_red : c_lime);