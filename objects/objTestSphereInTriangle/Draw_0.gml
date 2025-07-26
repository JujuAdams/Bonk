sphere.Draw(BonkSphereInsideTriangle(sphere, triangle)? c_lime : c_red, true);
triangle.Draw(c_white);

var _reaction = BonkSphereCollideTriangle(sphere, triangle);
if (_reaction.collision)
{
    UggSphere(sphere.x + _reaction.dX,
              sphere.y + _reaction.dY,
              sphere.z + _reaction.dZ,
              sphere.radius,
              c_white);
}