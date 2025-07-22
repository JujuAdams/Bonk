UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

sphereA.Draw(BonkBoolSphereInWall(sphereA, wall)? c_red : c_lime);
sphereB.Draw(BonkBoolSphereInWall(sphereB, wall)? c_red : c_lime);
sphereC.Draw(BonkBoolSphereInWall(sphereC, wall)? c_red : c_lime);