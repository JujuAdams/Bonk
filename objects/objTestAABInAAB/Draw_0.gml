aabA.DebugDraw(c_white, true);
aabB.DebugDraw(BonkAABTouchAAB(aabA, aabB)? c_red : c_lime);
aabC.DebugDraw(BonkAABTouchAAB(aabA, aabC)? c_red : c_lime);