UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

point.Draw(BonkBoolPointInSphere(point, sphere)? c_red : c_lime);