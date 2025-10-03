aabA.Draw(c_white, true);
aabB.Draw(BonkAABTouchAAB(aabA, aabB)? c_red : c_lime);
aabC.Draw(BonkAABTouchAAB(aabA, aabC)? c_red : c_lime);