capsule.Draw(BonkBoolCapsuleInQuad(capsule, quad)? c_lime : c_red, true);
quad.Draw(c_white, true);

var _reaction = BonkCapsuleInQuad(capsule, quad);
if (_reaction.collision)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}