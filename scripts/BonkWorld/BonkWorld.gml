// Feather disable all

/// @param xSize
/// @param ySize
/// @param zSize
/// @param cellXYSize
/// @param cellZSize

function BonkWorld(_xSize, _ySize, _zSize, _cellXYSize, _cellZSize) constructor
{
    __xSize = _xSize;
    __ySize = _ySize;
    __zSize = _zSize;
    
    __cellXYSize = _cellXYSize;
    __cellZSize  = _cellZSize;
    
    __cellXCount = ceil(_xSize / _cellXYSize);
    __cellYCount = ceil(_ySize / _cellXYSize);
    __cellZCount = ceil(_zSize / _cellZSize);
    
    __cellCount = __cellXCount*__cellYCount*__cellZCount;
    __cellArray = array_create_ext(__cellCount, function()
    {
        return [];
    });
    
    
    
    static PushOut = function(_subjectShape, _slopeThreshold)
    {
        var _shapeArray = GetShapeArray(_subjectShape.x, _subjectShape.y, _subjectShape.z);
        var _i = 0;
        repeat(array_length(_shapeArray))
        {
            _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
            ++_i;
        }
    }
    
    static MoveAndCollide = function(_velocityStruct, _subjectShape, _slopeThreshold = 36, _updateVelocity = true)
    {
        with(_subjectShape)
        {
            if (_updateVelocity)
            {
                var _x = x;
                var _y = y;
                var _z = z;
            }
        
            x += _velocityStruct.xSpeed;
            y += _velocityStruct.ySpeed;
            z += _velocityStruct.zSpeed;
            
            var _shapeArray = other.GetShapeArray(x, y, z);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                var _reaction = Collide(_shapeArray[_i]);
                if (_reaction.collision)
                {
                    var _dX = _reaction.dX;
                    var _dY = _reaction.dY;
                    var _dZ = _reaction.dZ;
                    
                    var _distance = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
                    if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                    {
                        //If the slope is shallow enough, just move upwards
                        //This movement is approximate but good enough
                        z += _distance;
                    }
                    else
                    {
                        //Otherwise move out as per normal which will typically slide the subject down slopes
                        x += _dX;
                        y += _dY;
                        z += _dZ;
                    }
                }
                
                ++_i;
            }
            
            if (_updateVelocity)
            {
                _velocityStruct.xSpeed = x - _x;
                _velocityStruct.ySpeed = y - _y;
                _velocityStruct.zSpeed = z - _z;
            }
        }
    }
    
    static Add = function(_shape)
    {
        var _aabb = _shape.GetAABB();
        
        var _cellX = clamp(floor((_aabb.x1 / __cellXYSize) - 0.5), 0, __cellXCount-1);
        var _cellY = clamp(floor((_aabb.y1 / __cellXYSize) - 0.5), 0, __cellYCount-1);
        var _cellZ = clamp(floor((_aabb.z1 / __cellZSize ) - 0.5), 0, __cellZCount-1);
        
        var _cellXSize = 1 + clamp(floor((_aabb.x2 / __cellXYSize) + 0.5), 0, __cellXCount-1) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.y2 / __cellXYSize) + 0.5), 0, __cellYCount-1) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.z2 / __cellZSize ) + 0.5), 0, __cellZCount-1) - _cellZ;
        
        var _z = _cellZ;
        repeat(_cellZSize)
        {
            var _y = _cellY;
            repeat(_cellYSize)
            {
                var _x = _cellX;
                repeat(_cellXSize)
                {
                    array_push(__cellArray[_x + __cellXCount*(_y + __cellYCount*_z)], _shape);
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
    }
    
    static GetShapeArray = function(_x, _y, _z)
    {
        return __cellArray[clamp(floor(_x / __cellXYSize), 0, __cellXCount-1) + __cellXCount*(clamp(floor(_y / __cellXYSize), 0, __cellYCount-1) + __cellYCount*clamp(floor(_z / __cellZSize ), 0, __cellZCount-1))];
    }
}