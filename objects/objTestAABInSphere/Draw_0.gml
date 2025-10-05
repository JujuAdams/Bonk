UggSetWireframe(true);
sphere.DebugDraw();
UggSetWireframe(false);

aabA.DebugDraw(BonkAABTouchSphere(aabA, sphere)? c_red : c_lime);
aabB.DebugDraw(BonkAABTouchSphere(aabB, sphere)? c_red : c_lime);