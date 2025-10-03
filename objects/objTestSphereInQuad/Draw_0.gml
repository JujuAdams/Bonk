sphere.Draw(BonkSphereTouchQuad(sphere, quad)? c_lime : c_red);
quad.Draw();

var _reaction = BonkSphereCollideQuad(sphere, quad);
if (_reaction.collision)
{
    UggSphere(sphere.x + _reaction.dX,
              sphere.y + _reaction.dY,
              sphere.z + _reaction.dZ,
              sphere.radius,
              c_white, true);
}