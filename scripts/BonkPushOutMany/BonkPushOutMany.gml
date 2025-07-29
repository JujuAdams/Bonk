// Feather disable all

/// Pushes a shape (the "subject shape") outside any and all of the shapes in the shape array.
/// 
/// The `slopeThreshold` argument is measured in degrees and referes to the gradient angle of
/// colliding surfaces that the surface bumps into. A slope threshold of `0` degrees is a flat
/// floor, a slope threshold of `90` degrees is a flat wall.
/// 
/// If, at the point of collision with a shape, a slope has a gradient angle lower than the
/// threshold then the subject shape will be pushed up (positive z) out of the shape instead of
/// sliding out of it. If the slope is steeper than the threshold (the slope gradient angle is
/// greater than the slope threshold) then the subject shape will slide off the surface.
/// 
/// You will typically want to leave the slope threshold at `0` for any "physics objects" in your
/// game; that is, objects that are intended move and roll around the environment freely. The
/// player character and non-player characters alike will want a slope threshold of some kind. I
/// personally like an angle of `40` degrees.
/// 
/// @param shapeArray
/// @param subjectShape
/// @param [slopeThreshold=0]

function BonkPushOutMany(_shapeArray, _subjectShape, _slopeThreshold = 0)
{
    var _i = 0;
    repeat(array_length(_shapeArray))
    {
        _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
        ++_i;
    }
}