UggSetWireframe(true);
sphereA.Draw();
UggSetWireframe(false);

sphereB.Draw(BonkSphereTouchSphere(sphereA, sphereB)? c_red : c_lime);
sphereC.Draw(BonkSphereTouchSphere(sphereA, sphereC)? c_red : c_lime);