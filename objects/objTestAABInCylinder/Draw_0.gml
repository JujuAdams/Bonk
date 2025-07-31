UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

aabA.Draw(BonkAABInsideCylinder(aabA, cylinder)? c_red : c_lime);
aabB.Draw(BonkAABInsideCylinder(aabB, cylinder)? c_red : c_lime);