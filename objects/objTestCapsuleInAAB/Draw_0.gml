capsule.DebugDraw(BonkCapsuleTouchAAB(capsule, aab)? c_lime : c_red, false);
aab.DebugDraw(c_white, false);

var _reaction = BonkCapsuleCollideAAB(capsule, aab);
if (_reaction.shape != undefined)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}