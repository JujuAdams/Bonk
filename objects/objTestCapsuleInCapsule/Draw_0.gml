capsule1.Draw(BonkCapsuleTouchCapsule(capsule1, capsule2)? c_lime : c_red);
capsule2.Draw();

var _reaction = BonkCapsuleCollideCapsule(capsule1, capsule2);
if (_reaction.shape != undefined)
{
    UggCapsule(capsule1.x + _reaction.dX,
               capsule1.y + _reaction.dY,
               capsule1.z - 0.5*capsule1.height + _reaction.dZ,
               capsule1.height, capsule1.radius,
               c_white, true);
}