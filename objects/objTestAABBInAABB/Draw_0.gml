UggSetWireframe(true);
aabbA.Draw();
UggSetWireframe(false);

aabbB.Draw(BonkAABBInAABB(aabbA, aabbB)? c_red : c_lime);
aabbC.Draw(BonkAABBInAABB(aabbA, aabbC)? c_red : c_lime);