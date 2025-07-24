aabbA.Draw(c_white, true);
aabbB.Draw(BonkBoolAABBInAABB(aabbA, aabbB)? c_red : c_lime);
aabbC.Draw(BonkBoolAABBInAABB(aabbA, aabbC)? c_red : c_lime);