UggSetWireframe(true);
sphereA.Draw();
UggSetWireframe(false);

sphereB.Draw(BonkBoolSphereInSphere(sphereA, sphereB)? c_red : c_lime);
sphereC.Draw(BonkBoolSphereInSphere(sphereA, sphereC)? c_red : c_lime);