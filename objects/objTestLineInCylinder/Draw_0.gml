UggSetWireframe(true);
cylinder.Draw();
UggSetWireframe(false);

var _i = 0;
repeat(array_length(lineArray))
{
    var _line = lineArray[_i];
    _line.Draw(BonkBoolLineInCylinder(_line, cylinder)? c_red : c_lime);
    ++_i;
}