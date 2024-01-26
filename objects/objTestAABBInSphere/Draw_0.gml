UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkAABBInSphere(aabbA, sphere)? c_red : c_lime);
aabbB.Draw(BonkAABBInSphere(aabbB, sphere)? c_red : c_lime);