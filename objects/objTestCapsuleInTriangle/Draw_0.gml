capsule.Draw(BonkBoolCapsuleInTriangle(capsule, triangle)? c_lime : c_red, true);
triangle.Draw(c_white, true);

var _reaction = BonkCapsuleInTriangle(capsule, triangle);
if (_reaction.collision)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}