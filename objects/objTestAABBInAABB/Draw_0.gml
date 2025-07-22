UggSetWireframe(true);
aabbA.Draw();
UggSetWireframe(false);

aabbB.Draw(BonkBoolAABBInAABB(aabbA, aabbB)? c_red : c_lime);
aabbC.Draw(BonkBoolAABBInAABB(aabbA, aabbC)? c_red : c_lime);