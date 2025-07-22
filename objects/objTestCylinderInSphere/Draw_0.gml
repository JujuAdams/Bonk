UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkBoolCylinderInSphere(cylinderA, sphere)? c_red : c_lime);
cylinderB.Draw(BonkBoolCylinderInSphere(cylinderB, sphere)? c_red : c_lime);