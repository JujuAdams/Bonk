UggSetWireframe(true);
sphereA.DebugDraw();
UggSetWireframe(false);

sphereB.DebugDraw(BonkSphereTouchSphere(sphereA, sphereB)? c_red : c_lime);
sphereC.DebugDraw(BonkSphereTouchSphere(sphereA, sphereC)? c_red : c_lime);