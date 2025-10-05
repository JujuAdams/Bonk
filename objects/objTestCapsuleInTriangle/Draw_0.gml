capsule.DebugDraw(BonkCapsuleTouchTriangle(capsule, triangle)? c_lime : c_red, false);
triangle.DebugDraw(c_white, false);

var _reaction = BonkCapsuleCollideTriangle(capsule, triangle);
if (_reaction.shape != undefined)
{
    UggCapsule(capsule.x + _reaction.dX,
               capsule.y + _reaction.dY,
               capsule.z - 0.5*capsule.height + _reaction.dZ,
               capsule.height, capsule.radius,
               c_white, true);
}