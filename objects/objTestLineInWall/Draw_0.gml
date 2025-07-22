UggSetWireframe(true);
wall.Draw();
UggSetWireframe(false);

var _i = 0;
repeat(array_length(lineArray))
{
    var _line = lineArray[_i];
    _line.Draw(BonkBoolLineInWall(_line, wall)? c_red : c_lime);
    ++_i;
}