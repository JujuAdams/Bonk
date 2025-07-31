UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkAABBInsideCylinder(aabbA, cylinder)? c_red : c_lime);
aabbB.Draw(BonkAABBInsideCylinder(aabbB, cylinder)? c_red : c_lime);