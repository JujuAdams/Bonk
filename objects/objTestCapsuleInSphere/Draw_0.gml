//capsule.DebugDraw(BonkCapsuleTouchSphere(capsule, sphere)? c_lime : c_red);
sphere.DebugDraw();

var _reaction = BonkCapsuleCollideSphere(capsule, sphere);
if (_reaction.shape != undefined)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}