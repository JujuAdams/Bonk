capsule1.Draw(BonkCapsuleInsideRotatedBox(capsule1, rotatedBox)? c_lime : c_red);
capsule2.Draw(BonkCapsuleInsideRotatedBox(capsule2, rotatedBox)? c_lime : c_red);
rotatedBox.Draw(c_white);

var _reaction = BonkCapsuleCollideRotatedBox(capsule1, rotatedBox);
if (_reaction.collision)
{
    UggCapsule(capsule1.x + _reaction.dX,
               capsule1.y + _reaction.dY,
               capsule1.z + _reaction.dZ - 0.5*capsule1.height,
               capsule1.height, capsule1.radius,
               c_white, true);
}

var _reaction = BonkCapsuleCollideRotatedBox(capsule2, rotatedBox);
if (_reaction.collision)
{
    UggCapsule(capsule2.x + _reaction.dX,
               capsule2.y + _reaction.dY,
               capsule2.z + _reaction.dZ - 0.5*capsule2.height,
               capsule2.height, capsule2.radius,
               c_white, true);
}