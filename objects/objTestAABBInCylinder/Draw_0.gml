UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkAABBInCylinder(aabbA, cylinder)? c_red : c_lime);
aabbB.Draw(BonkAABBInCylinder(aabbB, cylinder)? c_red : c_lime);