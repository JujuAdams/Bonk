UggSetWireframe(true);
sphere.DebugDraw();
UggSetWireframe(false);

cylinderA.DebugDraw(BonkCylinderTouchSphere(cylinderA, sphere)? c_red : c_lime);
cylinderB.DebugDraw(BonkCylinderTouchSphere(cylinderB, sphere)? c_red : c_lime);