UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkAABBInsideSphere(aabbA, sphere)? c_red : c_lime);
aabbB.Draw(BonkAABBInsideSphere(aabbB, sphere)? c_red : c_lime);