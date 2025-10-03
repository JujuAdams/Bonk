UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

aabA.Draw(BonkAABTouchCylinder(aabA, cylinder)? c_red : c_lime);
aabB.Draw(BonkAABTouchCylinder(aabB, cylinder)? c_red : c_lime);