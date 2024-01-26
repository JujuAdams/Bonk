UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

pointA.Draw(BonkPointInCylinder(pointA, cylinder)? c_red : c_lime);
pointB.Draw(BonkPointInCylinder(pointB, cylinder)? c_red : c_lime);