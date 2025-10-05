sphere.DebugDraw(BonkSphereTouchTriangle(sphere, triangle)? c_lime : c_red);
triangle.DebugDraw();

var _reaction = BonkSphereCollideTriangle(sphere, triangle);
if (_reaction.shape != undefined)
{
    UggSphere(sphere.x + _reaction.dX,
              sphere.y + _reaction.dY,
              sphere.z + _reaction.dZ,
              sphere.radius,
              c_white, true);
}