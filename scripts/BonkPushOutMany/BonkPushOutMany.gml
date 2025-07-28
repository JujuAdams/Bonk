// Feather disable all

/// @param shapeArray
/// @param subjectShape
/// @param [slopeThreshold=36]

function BonkPushOutMany(_shapeArray, _subjectShape, _slopeThreshold = 36)
{
    var _i = 0;
    repeat(array_length(_shapeArray))
    {
        _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
        ++_i;
    }
}