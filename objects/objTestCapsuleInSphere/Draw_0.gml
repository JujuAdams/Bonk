//capsule.Draw(BonkBoolCapsuleInSphere(capsule, sphere)? c_lime : c_red);
sphere.Draw();

var _reaction = BonkCapsuleInSphere(capsule, sphere);
if (_reaction.collision)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}