UggSetWireframe(true);
sphere.Draw();
UggSetWireframe(false);

aabbA.Draw(BonkBoolAABBInSphere(aabbA, sphere)? c_red : c_lime);
aabbB.Draw(BonkBoolAABBInSphere(aabbB, sphere)? c_red : c_lime);