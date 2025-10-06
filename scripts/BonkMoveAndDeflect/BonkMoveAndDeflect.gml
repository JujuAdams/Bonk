// Feather disable all

/// Applies a velocity struct to a Bonk instance and then pushes the subject instance out of any
/// Bonk structs/instances that are found by iterating over shapes found within the provided
/// `objectOrArray` parameter. Once collisions have been resolved, the velocity struct is updated
/// based on the distance that the instance has actually moved.
/// 
/// This function will then return deflect data (`BonkResultDeflect`) for the highest priority
/// collision. Collisions with slopes beneath the threshold ("grippy") take priority over
/// collisions with slopes above the threshold ("slippery") collisions, and higher depth
/// collisions take priority over lower depth collisions. The returned struct is statically
/// allocated and calling this function multiple times will reuse the same struct.
/// 
/// The `slopeThreshold` parameter is measured in degrees and referes to the gradient angle of
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
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param subjectInstance
/// @param velocityStruct
/// @param [slopeThreshold=0]
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkMoveAndDeflect(_subjectInstance, _velocityStruct, _slopeThreshold = 0, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkMoveAndDeflectExt(_subjectInstance, _velocityStruct, BonkInstancePlaceList(_subjectInstance, _velocityStruct.xSpeed, _velocityStruct.ySpeed, _objectOrArray), _slopeThreshold, _groupFilter);
}