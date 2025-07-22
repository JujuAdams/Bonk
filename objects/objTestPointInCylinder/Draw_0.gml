UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

pointA.Draw(BonkBoolPointInCylinder(pointA, cylinder)? c_red : c_lime);
pointB.Draw(BonkBoolPointInCylinder(pointB, cylinder)? c_red : c_lime);