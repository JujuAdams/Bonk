sphere.Draw(BonkSphereInsideRotatedBox(sphere, rotatedBox)? c_lime : c_red);
rotatedBox.Draw();

var _reaction = BonkSphereCollideRotatedBox(sphere, rotatedBox);
if (_reaction.collision)
{
    UggSphere(sphere.x + _reaction.dX,
              sphere.y + _reaction.dY,
              sphere.z + _reaction.dZ,
              sphere.radius,
              c_white, true);
}