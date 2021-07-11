function BonkMatrixScale(_xScale, _yScale, _zScale, _matrix)
{
    if (_matrix == undefined)
    {
        return matrix_build(0,0,0,   0,0,0,   _xScale, _yScale, _zScale);
    }
    else
    {
        return matrix_multiply(_matrix, matrix_build(0,0,0,   1,1,1,   _xScale, _yScale, _zScale));
    }
}