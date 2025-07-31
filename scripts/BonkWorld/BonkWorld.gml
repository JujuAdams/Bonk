// Feather disable all

/// Constructor to make a struct that organizes a large group of Bonk shapes into a 3D grid for
/// quick collision queries.
/// 
/// @param xSize
/// @param ySize
/// @param zSize
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkWorld(_xSize, _ySize, _zSize, _cellXSize, _cellYSize, _cellZSize) constructor
{
    static bonkType = BONK_TYPE_WORLD;
    
    __xSize = _xSize;
    __ySize = _ySize;
    __zSize = _zSize;
    
    __cellXSize = _cellXSize;
    __cellYSize = _cellYSize;
    __cellZSize = _cellZSize;
    
    __cellXCount = ceil(_xSize / _cellXSize);
    __cellYCount = ceil(_ySize / _cellYSize);
    __cellZCount = ceil(_zSize / _cellZSize);
    
    __cellCount = __cellXCount*__cellYCount*__cellZCount;
    __cellArray = array_create_ext(__cellCount, function()
    {
        return [];
    });
    
    
    
    static PushOut = function(_subjectShape, _slopeThreshold = 0)
    {
        static _map = ds_map_create();
        
        var _cheapVersion = true;
        
        var _aabb = _subjectShape.GetAABB();
        with(_aabb)
        {
            if ((xMax - xMin > 2*other.__cellXSize) || (yMax - yMin > 2*other.__cellYSize) || (zMax - zMin > 2*other.__cellZSize))
            {
                _cheapVersion = false;
            }
        }
        
        if (_cheapVersion)
        {
            var _shapeArray = GetShapeArray(_subjectShape.x, _subjectShape.y, _subjectShape.z);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.x1 / __cellXSize), 0, __cellXCount-1);
            var _cellY = clamp(floor(_aabb.y1 / __cellYSize), 0, __cellYCount-1);
            var _cellZ = clamp(floor(_aabb.z1 / __cellZSize), 0, __cellZCount-1);
            
            var _cellXSize = 1 + clamp(floor(_aabb.x2 / __cellXSize), 0, __cellXCount-1) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.y2 / __cellYSize), 0, __cellYCount-1) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.z2 / __cellZSize), 0, __cellZCount-1) - _cellZ;
            
            var _z = _cellZ;
            repeat(_cellZSize)
            {
                var _y = _cellY;
                repeat(_cellYSize)
                {
                    var _x = _cellX;
                    repeat(_cellXSize)
                    {
                        var _shapeArray = __cellArray[_x + __cellXCount*(_y + __cellYCount*_z)];
                        
                        var _i = 0;
                        repeat(array_length(_shapeArray))
                        {
                            var _shape = _shapeArray[_i];
                            if (not ds_map_exists(_map, _shape))
                            {
                                _map[? _shape] = true;
                                _shape.PushOut(_subjectShape, _slopeThreshold);
                            }
                            
                            ++_i;
                        }
                        
                        ++_x;
                    }
                    
                    ++_y;
                }
                
                ++_z;
            }
            
            ds_map_clear(_map);
        }
    }
    
    static Add = function(_shape)
    {
        if ((_shape.bonkType == BONK_TYPE_LINE) || (_shape.bonkType == BONK_TYPE_RAY) || (_shape.bonkType = BONK_TYPE_POINT))
        {
            if (BONK_STRICT)
            {
                __BonkError($"Cannot add {instanceof(_shape)} to a `BonkWorld()`");
            }
            
            return;
        }
        
        var _aabb = _shape.GetAABB();
        
        var _cellX = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), 0, __cellXCount-1);
        var _cellY = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), 0, __cellYCount-1);
        var _cellZ = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), 0, __cellZCount-1);
        
        var _cellXSize = 1 + clamp(floor((_aabb.xMax / __cellXSize) + 0.5), 0, __cellXCount-1) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.yMax / __cellYSize) + 0.5), 0, __cellYCount-1) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.zMax / __cellZSize) + 0.5), 0, __cellZCount-1) - _cellZ;
        
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
        return __cellArray[clamp(floor(_x / __cellXSize), 0, __cellXCount-1) + __cellXCount*(clamp(floor(_y / __cellYSize), 0, __cellYCount-1) + __cellYCount*clamp(floor(_z / __cellZSize ), 0, __cellZCount-1))];
    }
}