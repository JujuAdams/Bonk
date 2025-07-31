UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

aabA.Draw(BonkAABInsideSphere(aabA, sphere)? c_red : c_lime);
aabB.Draw(BonkAABInsideSphere(aabB, sphere)? c_red : c_lime);