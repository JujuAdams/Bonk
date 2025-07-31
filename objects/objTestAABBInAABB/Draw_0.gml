aabbA.Draw(c_white, true);
aabbB.Draw(BonkAABBInsideAABB(aabbA, aabbB)? c_red : c_lime);
aabbC.Draw(BonkAABBInsideAABB(aabbA, aabbC)? c_red : c_lime);