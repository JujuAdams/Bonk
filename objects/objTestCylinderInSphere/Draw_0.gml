UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkCylinderInSphere(cylinderA, sphere)? c_red : c_lime);
cylinderB.Draw(BonkCylinderInSphere(cylinderB, sphere)? c_red : c_lime);