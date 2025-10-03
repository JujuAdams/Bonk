// Feather disable all

/// @param shapeArray
/// @param subjectShape

function BonkTouchAny(_shapeArray, _subjectShape)
{
    var _i = 0;
    repeat(array_length(_shapeArray))
    {
        if (_shapeArray[_i].Touch(_subjectShape))
        {
            return true;
        }
        
        ++_i;
    }
    
    return false;
}