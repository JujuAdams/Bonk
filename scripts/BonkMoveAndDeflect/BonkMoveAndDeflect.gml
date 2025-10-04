// Feather disable all

/// @param subjectShape
/// @param velocityStruct
/// @param targetShapes
/// @param [slopeThreshold=0]
/// @param [groupFilter]

function BonkMoveAndDeflect(_subjectShape, _velocityStruct, _targetShapes, _slopeThreshold = 0, _groupFilter = -1)
{
    static _nullDeflectData = __Bonk().__nullDeflectData;
    var _returnData = _nullDeflectData;
    
    with(_subjectShape)
    {
        var _x = x;
        var _y = y;
        var _z = z;
        
        AddVelocity(_velocityStruct);
        _returnData = BonkDeflectMany(_subjectShape, _targetShapes, _slopeThreshold, _groupFilter);
        
        _velocityStruct.xSpeed = x - _x;
        _velocityStruct.ySpeed = y - _y;
        _velocityStruct.zSpeed = z - _z;
    }
    
    return _returnData;
}