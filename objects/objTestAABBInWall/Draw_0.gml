UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkBoolAABBInWall(aabbA, wall)? c_red : c_lime);
aabbB.Draw(BonkBoolAABBInWall(aabbB, wall)? c_red : c_lime);