shape.DebugDraw();
//shape.DrawShapes();

//__BonkSetWorldMatrix(shape.x, shape.y, shape.z);
//UggSetShader();
//vertex_submit(vbuffVolume, pr_trianglelist, -1);
//shader_reset();
//__BonkResetWorldMatrix();

testX += 2*(keyboard_check(vk_right) - keyboard_check(vk_left));
testY += 2*(keyboard_check(vk_down) - keyboard_check(vk_up));
testZ -= 3;

var _collision = BonkPointCollideHeightmap(shape, testX, testY, testZ);
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

UggPoint(100, 100, 0, BonkPointTouchHeightmap(shape, 100, 100, 0)? c_red : c_lime);

var _z = 120*dsin(current_time/20);
UggPoint(150, 150, _z, BonkPointTouchHeightmap(shape, 150, 150, _z)? c_red : c_lime);

UggSphere(testX, testY, testZ+10, 10, c_fuchsia);
UggSphere(0, 0, 10, 10, c_fuchsia);

var _x1 = 150;
var _y1 = 160;
var _z1 = 140;
var _x2 = 5*(220 - _x1);
var _y2 = 5*(230 - _y1);
var _z2 = 5*(100 - _z1);
UggArrow(_x1, _y1, _z1,   _x2, _y2, _z2,   undefined, undefined, undefined, true);

var _result = BonkLineHitHeightmapNew(shape,   _x1, _y1, _z1,   _x2, _y2, _z2);
if (_result.shape != undefined)
{
    UggSphere(_result.x, _result.y, _result.z, 4, c_lime);
}