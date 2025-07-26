UggSetWireframe(true);
sphereA.Draw();
UggSetWireframe(false);

sphereB.Draw(BonkSphereInsideSphere(sphereA, sphereB)? c_red : c_lime);
sphereC.Draw(BonkSphereInsideSphere(sphereA, sphereC)? c_red : c_lime);