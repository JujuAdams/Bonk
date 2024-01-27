UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkAABBInWall(aabbA, wall)? c_red : c_lime);
aabbB.Draw(BonkAABBInWall(aabbB, wall)? c_red : c_lime);