UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

cylinderA.Draw(BonkCylinderInsideSphere(cylinderA, sphere)? c_red : c_lime);
cylinderB.Draw(BonkCylinderInsideSphere(cylinderB, sphere)? c_red : c_lime);