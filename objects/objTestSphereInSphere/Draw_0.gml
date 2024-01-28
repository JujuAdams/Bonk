UggSetWireframe(true);
sphereA.Draw();
UggSetWireframe(false);

sphereB.Draw(BonkSphereInSphere(sphereA, sphereB)? c_red : c_lime);
sphereC.Draw(BonkSphereInSphere(sphereA, sphereC)? c_red : c_lime);