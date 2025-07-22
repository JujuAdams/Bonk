UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkBoolAABBInCylinder(aabbA, cylinder)? c_red : c_lime);
aabbB.Draw(BonkBoolAABBInCylinder(aabbB, cylinder)? c_red : c_lime);