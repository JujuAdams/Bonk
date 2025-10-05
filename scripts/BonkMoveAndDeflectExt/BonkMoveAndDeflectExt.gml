// Feather disable all

/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// @param subjectShape
/// @param velocityStruct
/// @param targetShapes
/// @param [slopeThreshold=0]
/// @param [groupFilter]

function BonkMoveAndDeflectExt(_subjectShape, _velocityStruct, _targetShapes, _slopeThreshold = 0, _groupFilter = -1)
{
    static _nullDeflectData = __Bonk().__nullDeflectData;
    var _returnData = _nullDeflectData;
    
    with(_subjectShape)
    {
        var _x = x;
        var _y = y;
        var _z = z;
        
        AddVelocity(_velocityStruct);
        _returnData = BonkDeflectManyExt(_subjectShape, _targetShapes, _slopeThreshold, _groupFilter);
        
        _velocityStruct.xSpeed = x - _x;
        _velocityStruct.ySpeed = y - _y;
        _velocityStruct.zSpeed = z - _z;
    }
    
    return _returnData;
}