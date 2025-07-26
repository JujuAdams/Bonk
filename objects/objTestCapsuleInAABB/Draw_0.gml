capsule.Draw(BonkCapsuleInsideAABB(capsule, aabb)? c_lime : c_red, false);
aabb.Draw(c_white, false);

var _reaction = BonkCapsuleInAABB(capsule, aabb);
if (_reaction.collision)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}