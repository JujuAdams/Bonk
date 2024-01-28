UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

sphereA.Draw(BonkSphereInWall(sphereA, wall)? c_red : c_lime);
sphereB.Draw(BonkSphereInWall(sphereB, wall)? c_red : c_lime);
sphereC.Draw(BonkSphereInWall(sphereC, wall)? c_red : c_lime);