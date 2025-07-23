capsule.Draw(BonkBoolCapsuleInTriangle(capsule, triangle)? c_lime : c_red, false);
triangle.Draw(c_white, false);

var _reaction = BonkCapsuleInTriangle(capsule, triangle);
if (_reaction.collision)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}