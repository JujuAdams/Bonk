UggSetWireframe(true);
triangle.Draw();
UggSetWireframe(false);

var _i = 0;
repeat(array_length(lineArray))
{
    var _line = lineArray[_i];
    _line.Draw(BonkLineInTriangle(_line, triangle)? c_red : c_lime);
    ++_i;
}