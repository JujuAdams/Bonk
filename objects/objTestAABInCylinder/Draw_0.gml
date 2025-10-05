UggSetWireframe(true);
cylinder.DebugDraw();
UggSetWireframe(false);

aabA.DebugDraw(BonkAABTouchCylinder(aabA, cylinder)? c_red : c_lime);
aabB.DebugDraw(BonkAABTouchCylinder(aabB, cylinder)? c_red : c_lime);