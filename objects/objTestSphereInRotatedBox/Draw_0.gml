sphere1.Draw(BonkSphereInsideRotatedBox(sphere1, rotatedBox)? c_lime : c_red);
sphere2.Draw(BonkSphereInsideRotatedBox(sphere2, rotatedBox)? c_lime : c_red);
rotatedBox.Draw();

var _reaction = BonkSphereCollideRotatedBox(sphere1, rotatedBox);
if (_reaction.collision)
{
    UggSphere(sphere1.x + _reaction.dX,
              sphere1.y + _reaction.dY,
              sphere1.z + _reaction.dZ,
              sphere1.radius,
              c_white, true);
}

var _reaction = BonkSphereCollideRotatedBox(sphere2, rotatedBox);
if (_reaction.collision)
{
    UggSphere(sphere2.x + _reaction.dX,
              sphere2.y + _reaction.dY,
              sphere2.z + _reaction.dZ,
              sphere2.radius,
              c_white, true);
}