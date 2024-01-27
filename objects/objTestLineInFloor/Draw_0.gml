UggSetWireframe(true);
floor_.Draw();
UggSetWireframe(false);

var _i = 0;
repeat(array_length(lineArray))
{
    var _line = lineArray[_i];
    _line.Draw(BonkLineInFloor(_line, floor_)? c_red : c_lime);
    ++_i;
}