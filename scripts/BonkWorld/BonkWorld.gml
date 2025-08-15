// Feather disable all

/// Constructor to make a struct that organizes a large group of Bonk shapes into a 3D grid for
/// quick collision queries.
/// 
/// `.Add(shape)`
///     Adds the shape permanently to the "world".
/// 
/// `.GetShapeArray(x, y, z)`
///     Returns an array that contains shapes that may overlap with the specified point.
/// 
/// `.PushOut(subjectShape, [slopeThreshold=0])`
///     Pushes the subject shape out of the shapes added to the world. The slope threshold will
///     allow shapes to "stand" on slopes instead of sliding down them. The units of this parameter
///     are degrees. An angle of `0` represents a perfectly horizontal floor plane. Increase this
///     value to allow shapes to stand on steeper slopes.
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
        if ((_shape.bonkType == BONK_TYPE_LINE)
        ||  (_shape.bonkType == BONK_TYPE_RAY)
        ||  (_shape.bonkType == BONK_TYPE_POINT))
        {
            if (BONK_STRICT)
            {
                __BonkError($"Cannot add {instanceof(_shape)} to a `BonkWorld()`");
            }
            
            return;
        }
        
        if (_shape.__world != undefined)
        {
            _shape.RemoveFromWorld();
        }
        
        _shape.__world = self;
        _shape.SetPosition = __SetPositionInWorld;
        
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
    
    static __RemoveShape = function(_shape)
    {
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
                    var _array = __cellArray[_x + __cellXCount*(_y + __cellYCount*_z)];
                    var _index = array_find_index(_array, _shape);
                    if (_index >= 0)
                    {
                        array_delete(_array, _index, 1);
                    }
                    
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
    }
    
    static __MoveShape = function(_dX, _dY, _dZ, _shape)
    {
        var _aabb = _shape.GetAABB();
        
        //TODO - This is expensive. Is there a better way of doing this?
        
        var _cellX = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), 0, __cellXCount-1);
        var _cellY = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), 0, __cellYCount-1);
        var _cellZ = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), 0, __cellZCount-1);
        
        var _cellXSize = 1 + clamp(floor((_aabb.xMax / __cellXSize) + 0.5), 0, __cellXCount-1) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.yMax / __cellYSize) + 0.5), 0, __cellYCount-1) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.zMax / __cellZSize) + 0.5), 0, __cellZCount-1) - _cellZ;
        
        with(_aabb)
        {
            xMin += _dX;
            yMin += _dY;
            zMin += _dZ;
            
            xMax += _dX;
            yMax += _dY;
            zMax += _dZ;
        }
        
        var _cellX2 = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), 0, __cellXCount-1);
        var _cellY2 = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), 0, __cellYCount-1);
        var _cellZ2 = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), 0, __cellZCount-1);
        
        var _cellXSize2 = 1 + clamp(floor((_aabb.xMax / __cellXSize) + 0.5), 0, __cellXCount-1) - _cellX;
        var _cellYSize2 = 1 + clamp(floor((_aabb.yMax / __cellYSize) + 0.5), 0, __cellYCount-1) - _cellY;
        var _cellZSize2 = 1 + clamp(floor((_aabb.zMax / __cellZSize) + 0.5), 0, __cellZCount-1) - _cellZ;
        
        if ((_cellX == _cellX2) && (_cellY == _cellY2) && (_cellZ == _cellZ2)
        &&  (_cellXSize == _cellXSize2) && (_cellYSize == _cellYSize2) && (_cellZSize == _cellZSize2))
        {
            //Hasn't move far enough for any changes to be made
            return;
        }
        
        //Remove from the previous zone
        var _z = _cellZ;
        repeat(_cellZSize)
        {
            var _y = _cellY;
            repeat(_cellYSize)
            {
                var _x = _cellX;
                repeat(_cellXSize)
                {
                    var _array = __cellArray[_x + __cellXCount*(_y + __cellYCount*_z)];
                    var _index = array_find_index(_array, _shape);
                    if (_index >= 0)
                    {
                        array_delete(_array, _index, 1);
                    }
                    
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
        
        //Add to the next zone
        var _z = _cellZ2;
        repeat(_cellZSize2)
        {
            var _y = _cellY2;
            repeat(_cellYSize2)
            {
                var _x = _cellX2;
                repeat(_cellXSize2)
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