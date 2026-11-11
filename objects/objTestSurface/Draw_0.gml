//shape.DebugDraw();
//shape.DrawShapes();

__BonkSetWorldMatrix(shape.x, shape.y, shape.z);
UggSetShader();
vertex_submit(vbuffVolume, pr_trianglelist, -1);
shader_reset();
__BonkResetWorldMatrix();

testX += 5*(keyboard_check(vk_right) - keyboard_check(vk_left));
testY += 5*(keyboard_check(vk_down) - keyboard_check(vk_up));
testZ -= 2;

var _collision = BonkPointCollideHeightmap(testX, testY, testZ, shape);
var _length = point_distance_3d(0, 0, 0, _collision.dX, _collision.dY, _collision.dZ);
if (_collision.dZ / max(0.0001, _length) > dcos(35))
{
    testZ += _length;
}
else
{
    testX += _collision.dX;
    testY += _collision.dY;
    testZ += _collision.dZ;
}

UggPoint(100, 100, 0, BonkPointTouchHeightmap(100, 100, 0, shape)? c_red : c_lime);

var _z = 120*dsin(current_time/20);
UggPoint(150, 150, _z, BonkPointTouchHeightmap(150, 150, _z, shape)? c_red : c_lime);

UggSphere(testX, testY, testZ+10, 10, c_fuchsia);
UggSphere(0, 0, 10, 10, c_fuchsia);

//BonkPointCollideHeightmap(testX, testY, testZ, shape);