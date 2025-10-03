UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkCylinderTouchSphere(cylinderA, sphere)? c_red : c_lime);
cylinderB.Draw(BonkCylinderTouchSphere(cylinderB, sphere)? c_red : c_lime);