UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

aabA.Draw(BonkAABTouchSphere(aabA, sphere)? c_red : c_lime);
aabB.Draw(BonkAABTouchSphere(aabB, sphere)? c_red : c_lime);