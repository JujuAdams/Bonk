/// @param subjectShape
/// @param slopeThreshold
/// @param collideStruct

function __BonkConvertCollideToDeflect(_subjectShape, _slopeThreshold, _collideStruct)
{
    static _staticDeflect = new BonkResultDeflect();
    var _result = _staticDeflect;
    
    //Handle the grippiest shape
    with(_collideStruct)
    {
        var _distance = point_distance_3d(0,0,0,   dX, dY, dZ);
        if ((dZ / max(0.00001, _distance)) > clamp(dcos(_slopeThreshold), 0, 1))
        {
            //If the slope is shallow enough, just move upwards
            //This movement is approximate but good enough
            _subjectShape.AddPosition(0, 0, _distance);
            
            with(_result)
            {
                other.__CopyTo(grippyCollision);
                slipperyCollision.Null();
                primaryCollision = grippyCollision;
                deflectType = BONK_DEFLECT_GRIPPY;
            }
        }
        else
        {
            //Otherwise move out as usual which will typically slide the subject down slopes
            _subjectShape.AddPosition(dX, dY, dZ);
            
            with(_result)
            {
                grippyCollision.Null();
                other.__CopyTo(slipperyCollision);
                primaryCollision = slipperyCollision;
                deflectType = BONK_DEFLECT_SLIPPERY;
            }
        }
    }
    
    return _result;
}