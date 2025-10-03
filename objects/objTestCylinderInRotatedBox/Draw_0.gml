cylinder1.Draw(BonkCylinderTouchRotatedBox(cylinder1, rotatedBox)? c_lime : c_red);
cylinder2.Draw(BonkCylinderTouchRotatedBox(cylinder2, rotatedBox)? c_lime : c_red);
rotatedBox.Draw(c_white);

var _reaction = BonkCylinderCollideRotatedBox(cylinder1, rotatedBox);
if (_reaction.collision)
{
    UggCylinder(cylinder1.x + _reaction.dX,
                cylinder1.y + _reaction.dY,
                cylinder1.z + _reaction.dZ - 0.5*cylinder1.height,
                cylinder1.height, cylinder1.radius,
                c_white, true);
}

var _reaction = BonkCylinderCollideRotatedBox(cylinder2, rotatedBox);
if (_reaction.collision)
{
    UggCylinder(cylinder2.x + _reaction.dX,
                cylinder2.y + _reaction.dY,
                cylinder2.z + _reaction.dZ - 0.5*cylinder2.height,
                cylinder2.height, cylinder2.radius,
                c_white, true);
}