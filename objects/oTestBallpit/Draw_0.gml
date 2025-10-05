// Feather disable all

//quadLeft.DebugDraw(c_white, true);
//quadTop.DebugDraw(c_white, true);
//quadBelow.DebugDraw(c_white, true);
//quadRight.DebugDraw(c_white, true);
//quadBottom.DebugDraw(c_white, true);
//quadAbove.DebugDraw(c_white, true);

var _i = 0;
repeat(array_length(sphereArray))
{
    sphereArray[_i].DebugDraw();
    ++_i;
}