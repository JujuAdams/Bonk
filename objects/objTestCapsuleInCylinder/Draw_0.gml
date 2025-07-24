capsule.Draw(BonkBoolCapsuleInCylinder(capsule, cylinder)? c_lime : c_red);
cylinder.Draw();

var _reaction = BonkCapsuleInCylinder(capsule, cylinder);
if (_reaction.collision)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}