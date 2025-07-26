sphere.Draw(BonkSphereInsideQuad(sphere, quad)? c_lime : c_red, true);
quad.Draw(c_white, true);

var _reaction = BonkSphereInQuad(sphere, quad);
if (_reaction.collision)
{
    UggSphere(sphere.x + _reaction.dX,
              sphere.y + _reaction.dY,
              sphere.z + _reaction.dZ,
              sphere.radius,
              c_white, true);
}