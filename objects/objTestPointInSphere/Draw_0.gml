UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

point.Draw(BonkPointInSphere(point, sphere)? c_red : c_lime);