aabA.Draw(c_white, true);
aabB.Draw(BonkAABInsideAAB(aabA, aabB)? c_red : c_lime);
aabC.Draw(BonkAABInsideAAB(aabA, aabC)? c_red : c_lime);