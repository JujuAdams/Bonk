// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize)
{
    bonkType = BONK_TYPE_WORLD;
    __lineHitFunction = BonkLineHitWorld;
    
    
    
    __cellXSize = _cellXSize;
    __cellYSize = _cellYSize;
    __cellZSize = _cellZSize;
    
    __minCellX = 0;
    __maxCellX = 0;
    __maxCellY = 0;
    __minCellY = 0;
    __minCellZ = 0;
    __maxCellZ = 0;
    
    __spatialDict = {};
    
    if (BONK_RUNNING_FROM_IDE)
    {
        __debugDict = {};
    }
    
    
    
    SetPosition = function() {};
    AddPosition = function() {};
    AddVelocity = function() {};
    
    Touch = function(_subjectShape, _groupFilter = -1)
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
            var _shapeArray = GetShapeArrayFromPoint(_subjectShape.x, _subjectShape.y, _subjectShape.z);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                if (_shapeArray[_i].Touch(_subjectShape, _groupFilter))
                {
                    return true;
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.xMin / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.yMin / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.zMin / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.xMax / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.yMax / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.zMax / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
            var _z = _cellZ;
            repeat(_cellZSize)
            {
                var _y = _cellY;
                repeat(_cellYSize)
                {
                    var _x = _cellX;
                    repeat(_cellXSize)
                    {
                        var _shapeArray = __GetShapeArrayFromCellUnsafe(_x, _y, _z);
                        
                        var _i = 0;
                        repeat(array_length(_shapeArray))
                        {
                            var _shape = _shapeArray[_i];
                            if (not ds_map_exists(_map, _shape))
                            {
                                _map[? _shape] = true;
                                
                                if (_shapeArray[_i].Touch(_subjectShape, _groupFilter))
                                {
                                    ds_map_clear(_map);
                                    return true;
                                }
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
        
        return false;
    }
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1)
    {
        static _map = ds_map_create();
        static _nullDeflectData = __Bonk().__nullDeflectData;
        
        var _returnData = _nullDeflectData;
        var _largestDepth = 0;
        
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
            var _shapeArray = GetShapeArrayFromPoint(_subjectShape.x, _subjectShape.y, _subjectShape.z);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                var _reaction = _shapeArray[_i].Deflect(_subjectShape, _slopeThreshold, _groupFilter);
                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnData.deflectType))
                        {
                            _largestDepth = _depth;
                            _returnData = _reaction.Clone();
                        }
                    }
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.xMin / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.yMin / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.zMin / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.xMax / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.yMax / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.zMax / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
            var _z = _cellZ;
            repeat(_cellZSize)
            {
                var _y = _cellY;
                repeat(_cellYSize)
                {
                    var _x = _cellX;
                    repeat(_cellXSize)
                    {
                        var _shapeArray = GetShapeArrayFromCell(_x, _y, _z);
                        
                        var _i = 0;
                        repeat(array_length(_shapeArray))
                        {
                            var _shape = _shapeArray[_i];
                            if (not ds_map_exists(_map, _shape))
                            {
                                _map[? _shape] = true;
                                
                                var _reaction = _shape.Deflect(_subjectShape, _slopeThreshold, _groupFilter);
                                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                                {
                                    with(_reaction.collisionData)
                                    {
                                        var _depth = dX*dX + dY*dY + dZ*dZ;
                                        if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnData.deflectType))
                                        {
                                            _largestDepth = _depth;
                                            _returnData = _reaction.Clone();
                                        }
                                    }
                                }
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
        
        return _returnData;
    }
    
    Collide = function(_subjectShape, _groupFilter = -1)
    {
        static _map = ds_map_create();
        static _nullCollisionData = __Bonk().__nullCollisionData;
        
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
            var _shapeArray = GetShapeArrayFromPoint(_subjectShape.x, _subjectShape.y, _subjectShape.z);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                var _reaction = _shapeArray[_i].Collide(_subjectShape, _groupFilter);
                if (_reaction.collision)
                {
                    return _reaction;
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.xMin / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.yMin / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.zMin / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.xMax / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.yMax / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.zMax / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
            var _z = _cellZ;
            repeat(_cellZSize)
            {
                var _y = _cellY;
                repeat(_cellYSize)
                {
                    var _x = _cellX;
                    repeat(_cellXSize)
                    {
                        var _shapeArray = __GetShapeArrayFromCellUnsafe(_x, _y, _z);
                        
                        var _i = 0;
                        repeat(array_length(_shapeArray))
                        {
                            var _shape = _shapeArray[_i];
                            if (not ds_map_exists(_map, _shape))
                            {
                                _map[? _shape] = true;
                                
                                var _reaction = _shape.Collide(_subjectShape, _groupFilter);
                                if (_reaction.collision)
                                {
                                    ds_map_clear(_map);
                                    return _reaction;
                                }
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
        
        return _nullCollisionData;
    }
    
    FilterTest = function()
    {
        return true;
    }
    
    CellInside = function(_x, _y, _z)
    {
        return ((_x >= __minCellX) && (_x <= __maxCellX)
             && (_y >= __minCellY) && (_y <= __maxCellY)
             && (_z >= __minCellZ) && (_z <= __maxCellZ));
    }
    
    GetAABB = function()
    {
        return {
            xMin: __cellXSize*__minCellX,
            yMin: __cellYSize*__minCellY,
            zMin: __cellZSize*__minCellZ,
            xMax: __cellXSize*(__maxCellX+1),
            yMax: __cellYSize*(__maxCellY+1),
            zMax: __cellZSize*(__maxCellZ+1),
        };
    }
    
    Add = function(_shape)
    {
        if (is_handle(_shape))
        {
            if (BONK_STRICT)
            {
                __BonkError("Cannot add instances to a BonkStructWorld");
            }
            
            return;
        }
        else if (not is_struct(_shape))
        {
            return;
        }
        else if (instance_exists(_shape))
        {
            if (BONK_STRICT)
            {
                __BonkError("Cannot add instances to a BonkStructWorld");
            }
            
            return;
        }
        
        __Add(_shape);
    }
    
    __Add = function(_shape)
    {
        if ((_shape.bonkType == BONK_TYPE_LINE)
        ||  (_shape.bonkType == BONK_TYPE_RAY)
        ||  (_shape.bonkType == BONK_TYPE_POINT))
        {
            if (BONK_STRICT)
            {
                __BonkError($"Cannot add {instanceof(_shape)} to a `BonkStructWorld()`");
            }
            
            return;
        }
        
        if (_shape.__world != undefined)
        {
            _shape.RemoveFromWorld();
        }
        
        _shape.__world = self;
        _shape.SetPosition = _shape.__SetPositionInWorld;
        
        var _aabb = _shape.GetAABB();
        
        var _cellX = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellX2 = clamp(floor((_aabb.xMax / __cellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY2 = clamp(floor((_aabb.yMax / __cellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ2 = clamp(floor((_aabb.zMax / __cellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        __minCellX = min(__minCellX, _cellX, _cellX2);
        __maxCellX = max(__maxCellX, _cellX, _cellX2);
        __minCellY = min(__minCellY, _cellY, _cellY2);
        __maxCellY = max(__maxCellY, _cellY, _cellY2);
        __minCellZ = min(__minCellZ, _cellZ, _cellZ2);
        __maxCellZ = max(__maxCellZ, _cellZ, _cellZ2);
        
        if (instance_exists(self))
        {
            var _left   = __cellXSize*__minCellX;
            var _top    = __cellYSize*__minCellY;
            var _right  = __cellXSize*__maxCellX;
            var _bottom = __cellYSize*__maxCellY;
            
            x = 0.5*(_left + _right);
            y = 0.5*(_top + _bottom);
            image_xscale = max(BONK_INSTANCE_MIN_SIZE, 1 + _right - _left) / BONK_MASK_SIZE;
            image_yscale = max(BONK_INSTANCE_MIN_SIZE, 1 + _bottom - _top) / BONK_MASK_SIZE;
        }
        
        var _cellXSize = 1 + _cellX2 - _cellX;
        var _cellYSize = 1 + _cellY2 - _cellY;
        var _cellZSize = 1 + _cellZ2 - _cellZ;
        
        var _z = _cellZ;
        repeat(_cellZSize)
        {
            var _y = _cellY;
            repeat(_cellYSize)
            {
                var _x = _cellX;
                repeat(_cellXSize)
                {
                    array_push(__EnsureShapeArrayFromCell(_x, _y, _z), _shape);
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
    }
    
    __RemoveShape = function(_shape)
    {
        var _aabb = _shape.GetAABB();
        
        var _cellX = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellXSize = 1 + clamp(floor((_aabb.xMax / __cellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.yMax / __cellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.zMax / __cellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
        
        var _z = _cellZ;
        repeat(_cellZSize)
        {
            var _y = _cellY;
            repeat(_cellYSize)
            {
                var _x = _cellX;
                repeat(_cellXSize)
                {
                    var _array = __EnsureShapeArrayFromCell(_x, _y, _z);
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
    
    __MoveShape = function(_dX, _dY, _dZ, _shape)
    {
        var _aabb = _shape.GetAABB();
        
        //TODO - This is expensive. Is there a better way of doing this?
        
        var _cellX = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellXSize = 1 + clamp(floor((_aabb.xMax / __cellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.yMax / __cellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.zMax / __cellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
        
        with(_aabb)
        {
            xMin += _dX;
            yMin += _dY;
            zMin += _dZ;
            
            xMax += _dX;
            yMax += _dY;
            zMax += _dZ;
        }
        
        var _cellX2 = clamp(floor((_aabb.xMin / __cellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY2 = clamp(floor((_aabb.yMin / __cellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ2 = clamp(floor((_aabb.zMin / __cellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellXSize2 = 1 + clamp(floor((_aabb.xMax / __cellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
        var _cellYSize2 = 1 + clamp(floor((_aabb.yMax / __cellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
        var _cellZSize2 = 1 + clamp(floor((_aabb.zMax / __cellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
        
        if ((_cellX == _cellX2) && (_cellY == _cellY2) && (_cellZ == _cellZ2)
        &&  (_cellXSize == _cellXSize2) && (_cellYSize == _cellYSize2) && (_cellZSize == _cellZSize2))
        {
            //Hasn't moved far enough for any changes to be made
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
                    var _array = __GetShapeArrayFromCellUnsafe(_x, _y, _z);
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
        
        __minCellX = min(__minCellX, _cellX, _cellX + _cellXSize - 1);
        __maxCellX = max(__maxCellX, _cellX, _cellX + _cellXSize - 1);
        __minCellY = min(__minCellY, _cellY, _cellY + _cellYSize - 1);
        __maxCellY = max(__maxCellY, _cellY, _cellY + _cellYSize - 1);
        __minCellZ = min(__minCellZ, _cellZ, _cellZ + _cellZSize - 1);
        __maxCellZ = max(__maxCellZ, _cellZ, _cellZ + _cellZSize - 1);
        
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
                    array_push(__EnsureShapeArrayFromCell(_x, _y, _z), _shape);
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
    }
    
    GetShapeArrayFromPoint = function(_x, _y, _z)
    {
        return GetShapeArrayFromCell(_x / __cellXSize, _y / __cellYSize, _z / __cellZSize);
    }
    
    GetShapeArrayFromCell = function(_x, _y, _z)
    {
        static _emptyArray = [];
        
        _x = floor(clamp(_x, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _y = floor(clamp(_y, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _z = floor(clamp(_z, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        
        return struct_get_from_hash(__spatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    __GetShapeArrayFromCellUnsafe = function(_x, _y, _z)
    {
        static _emptyArray = [];
        return struct_get_from_hash(__spatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    __EnsureShapeArrayFromCell = function(_x, _y, _z)
    {
        var _key = (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22);
        
        var _array = struct_get_from_hash(__spatialDict, _key);
        if (_array == undefined)
        {
            _array = [];
            struct_set_from_hash(__spatialDict, _key, _array);
            
            if (BONK_RUNNING_FROM_IDE)
            {
                __debugDict[$ $"{_x},{_y},{_z}"] = _array;
            }
        }
        
        return _array;
    }
    
    AddVertexBuffer = function(_vertexBufferArray, _vertexFormat, _matrix = undefined)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _vertexFormatInfo = vertex_format_get_info(_vertexFormat);
        var _vertexStride = _vertexFormatInfo.stride;
        var _triangleStride = 3*_vertexStride;
        
        var _elementsArray = _vertexFormatInfo.elements;
        var _positionOffset = undefined;
        var _i = 0;
        repeat(array_length(_elementsArray))
        {
            var _elementStruct = _elementsArray[_i];
            if ((_elementStruct.usage == vertex_usage_position) && (_elementStruct.size == 12))
            {
                _positionOffset = _elementStruct.offset;
                break;
            }
            
            ++_i;
        }
        
        if (_positionOffset == undefined)
        {
            __BonkError("Could not find position data in vertex format");
        }
        
        var _i = 0;
        repeat(array_length(_vertexBufferArray))
        {
            var _vertexBuffer = _vertexBufferArray[_i];
            
            var _vertexCount = vertex_get_number(_vertexBuffer);
            var _triangleCount = _vertexCount / 3;
            if (_triangleCount != floor(_triangleCount))
            {
                __BonkError($"Vertex buffer does not have a whole number of triangles (vertex count {_vertexCount} is not divisible by 3)");
            }
            
            var _buffer = buffer_create_from_vertex_buffer_ext(_vertexBuffer, buffer_fixed, 1, 0, _vertexCount);
            buffer_seek(_buffer, buffer_seek_start, _positionOffset);
            
            repeat(_triangleCount)
            {
                var _x1 = buffer_read(_buffer, buffer_f32);
                var _y1 = buffer_read(_buffer, buffer_f32);
                var _z1 = buffer_read(_buffer, buffer_f32);
                
                buffer_seek(_buffer, buffer_seek_relative, _vertexStride - 12);
                
                var _x2 = buffer_read(_buffer, buffer_f32);
                var _y2 = buffer_read(_buffer, buffer_f32);
                var _z2 = buffer_read(_buffer, buffer_f32);
                
                buffer_seek(_buffer, buffer_seek_relative, _vertexStride - 12);
                
                var _x3 = buffer_read(_buffer, buffer_f32);
                var _y3 = buffer_read(_buffer, buffer_f32);
                var _z3 = buffer_read(_buffer, buffer_f32);
                
                buffer_seek(_buffer, buffer_seek_relative, _vertexStride - 12);
                
                if (_matrix != undefined)
                {
                    var _a = matrix_transform_vertex(_matrix, _x1, _y1, _z1, 1);
                    var _b = matrix_transform_vertex(_matrix, _x2, _y2, _z2, 1);
                    var _c = matrix_transform_vertex(_matrix, _x3, _y3, _z3, 1);
                    
                    var _bonkTri = new BonkStructTriangle(_a[0], _a[1], _a[2],
                                                    _b[0], _b[1], _b[2],
                                                    _c[0], _c[1], _c[2]);
                }
                else
                {
                    var _bonkTri = new BonkStructTriangle(_x1, _y1, _z1,
                                                    _x2, _y2, _z2,
                                                    _x3, _y3, _z3);
                }
                
                __Add(_bonkTri); //Use the internal version to avoid expensive instance checks
            }
            
            buffer_delete(_buffer);
            
            ++_i;
        }
    }
    
    DrawAABB = function(_color = undefined, _wireframe = true)
    {
        with(GetAABB())
        {
            UggAABB(0.5*(xMin + xMax), 0.5*(yMin + yMax), 0.5*(zMin + zMax),
                    xMax - xMin, yMax - yMin, zMax - zMin,
                    _color, _wireframe);
        }
    }
    
    DrawShapesFromRange = function(_struct, _color = undefined, _wireframe = undefined)
    {
        static _map = ds_map_create();
        
        var _xMin = floor(clamp(_struct.xMin / __cellXSize, __minCellX, __maxCellX));
        var _yMin = floor(clamp(_struct.yMin / __cellYSize, __minCellY, __maxCellY));
        var _zMin = floor(clamp(_struct.zMin / __cellZSize, __minCellZ, __maxCellZ));
        var _xMax = floor(clamp(_struct.xMax / __cellXSize, __minCellX, __maxCellX));
        var _yMax = floor(clamp(_struct.yMax / __cellYSize, __minCellY, __maxCellY));
        var _zMax = floor(clamp(_struct.zMax / __cellZSize, __minCellZ, __maxCellZ));
        
        var _z = _zMin;
        repeat(1 + _zMax - _zMin)
        {
            var _y = _yMin;
            repeat(1 + _yMax - _yMin)
            {
                var _x = _xMin;
                repeat(1 + _xMax - _xMin)
                {
                    var _shapeArray = __GetShapeArrayFromCellUnsafe(_x, _y, _z);
                    var _i = 0;
                    repeat(array_length(_shapeArray))
                    {
                        var _shape = _shapeArray[_i];
                        if (not ds_map_exists(_map, _shape))
                        {
                            _map[? _shape] = true;    
                            _shape.Draw(_color, _wireframe);
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
    
    DrawShapesFromArray = function(_array, _color = undefined, _wireframe = undefined)
    {
        static _map = ds_map_create();
        
        var _minCellX = __minCellX;
        var _maxCellX = __maxCellX;
        var _minCellY = __minCellY;
        var _maxCellY = __maxCellY;
        var _minCellZ = __minCellZ;
        var _maxCellZ = __maxCellZ;
        
        var _j = 0;
        repeat(array_length(_array) div 3)
        {
            var _x = floor(clamp(_array[_j  ], _minCellX, _maxCellX));
            var _y = floor(clamp(_array[_j+1], _minCellY, _maxCellY));
            var _z = floor(clamp(_array[_j+2], _minCellZ, _maxCellZ));
            
            var _shapeArray = __GetShapeArrayFromCellUnsafe(_x, _y, _z);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                var _shape = _shapeArray[_i];
                if (not ds_map_exists(_map, _shape))
                {
                    _map[? _shape] = true;    
                    _shape.Draw(_color, _wireframe);
                }
                
                ++_i;
            }
            
            _j += 3;
        }
        
        ds_map_clear(_map);
    }
    
    DrawShapes = function(_color = undefined, _wireframe = undefined)
    {
        return DrawShapesFromRange(GetAABB(), _color, _wireframe);
    }
    
    DrawCellsFromArray = function(_array, _color = undefined, _wireframe = true)
    {
        var _cellXSize = __cellXSize;
        var _cellYSize = __cellYSize;
        var _cellZSize = __cellZSize;
        
        var _minCellX = __minCellX;
        var _maxCellX = __maxCellX;
        var _minCellY = __minCellY;
        var _maxCellY = __maxCellY;
        var _minCellZ = __minCellZ;
        var _maxCellZ = __maxCellZ;
        
        var _i = 0;
        repeat(array_length(_array) div 3)
        {
            var _x = floor(clamp(_array[_i  ], _minCellX, _maxCellX));
            var _y = floor(clamp(_array[_i+1], _minCellY, _maxCellY));
            var _z = floor(clamp(_array[_i+2], _minCellZ, _maxCellZ));
            
            UggAABB(_cellXSize*(_x + 0.5),
                    _cellYSize*(_y + 0.5),
                    _cellZSize*(_z + 0.5),
                    _cellXSize, _cellYSize, _cellZSize,
                    _color, _wireframe);
            
            _i += 3;
        }
    }
    
    DrawCellsFromRange = function(_struct, _color = undefined, _wireframe = true, _checkerboard = false)
    {
        var _cellXSize = __cellXSize;
        var _cellYSize = __cellYSize;
        var _cellZSize = __cellZSize;
        
        var _xMin = floor(clamp(_struct.xMin / _cellXSize, __minCellX, __maxCellX));
        var _yMin = floor(clamp(_struct.yMin / _cellYSize, __minCellY, __maxCellY));
        var _zMin = floor(clamp(_struct.zMin / _cellZSize, __minCellZ, __maxCellZ));
        var _xMax = floor(clamp(_struct.xMax / _cellXSize, __minCellX, __maxCellX));
        var _yMax = floor(clamp(_struct.yMax / _cellYSize, __minCellY, __maxCellY));
        var _zMax = floor(clamp(_struct.zMax / _cellZSize, __minCellZ, __maxCellZ));
        
        var _z = _zMin;
        repeat(1 + _zMax - _zMin)
        {
            var _y = _yMin;
            repeat(1 + _yMax - _yMin)
            {
                var _x = _xMin;
                repeat(1 + _xMax - _xMin)
                {
                    if ((not _checkerboard) || ((abs(_x + _y + _z) mod 2) == 1))
                    {
                        UggAABB(_cellXSize*(_x + 0.5),
                                _cellYSize*(_y + 0.5),
                                _cellZSize*(_z + 0.5),
                                _cellXSize, _cellYSize, _cellZSize,
                                _color, _wireframe);
                    }
                    
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
    }
    
    DrawCells = function(_color = undefined, _wireframe = true, _checkerboard = true)
    {
        return DrawCellsFromRange(GetAABB(), _color, _wireframe, _checkerboard);
    }
    
    GetCellsFromShape = function(_lineShape)
    {
        with(_lineShape)
        {
            if (bonkType == BONK_TYPE_LINE)
            {
                return other.GetCellsFromLine(x1, y1, z1,   x2, y2, z2);
            }
            else if (bonkType == BONK_TYPE_RAY)
            {
                return other.GetCellsFromLine(x, y, z,   x + BONK_RAY_LENGTH*dx, y + BONK_RAY_LENGTH*dy, z + BONK_RAY_LENGTH*dz);
            }
            else
            {
                __BonkError($"Can only get cells for shapes that are a line or a ray (type was {bonkType})");
            }
        }
        
        return [];
    }
    
    GetCellsFromLine = function(_x1, _y1, _z1, _x2, _y2, _z2)
    {
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        //FIXME - Calculate these values when changing bounds
        var _xMin = __minCellX*__cellXSize;
        var _yMin = __minCellY*__cellYSize;
        var _zMin = __minCellZ*__cellZSize;
        var _xMax = (__maxCellX+1)*__cellXSize;
        var _yMax = (__maxCellY+1)*__cellYSize;
        var _zMax = (__maxCellZ+1)*__cellZSize;
        
        if (_dX == 0)
        {
            var _t1 = -infinity;
            var _t2 =  infinity;
        }
        else
        {
            var _t1 = (_xMin - _x1) / _dX;
            var _t2 = (_xMax - _x1) / _dX;
        }
        
        if (_dY == 0)
        {
            var _t3 = -infinity;
            var _t4 =  infinity;
        }
        else
        {
            var _t3 = (_yMin - _y1) / _dY;
            var _t4 = (_yMax - _y1) / _dY;
        }
        
        if (_dZ == 0)
        {
            var _t5 = -infinity;
            var _t6 =  infinity;
        }
        else
        {
            var _t5 = (_zMin - _z1) / _dZ;
            var _t6 = (_zMax - _z1) / _dZ;
        }
        
        var _tMin = max(min(_t1, _t2), min(_t3, _t4), min(_t5, _t6));
        var _tMax = min(max(_t1, _t2), max(_t3, _t4), max(_t5, _t6));
        
        if ((_tMax < 0) || (_tMin > 1) || (_tMin > _tMax))
        {
            return [];
        }
        
        _tMin = clamp(_tMin, 0, 1);
        _tMax = clamp(_tMax, 0, 1);
        
        var _t = (_tMin < 0)? _tMax : _tMin;
        
        var _cellXSize = __cellXSize;
        var _cellYSize = __cellYSize;
        var _cellZSize = __cellZSize;
        
        var _hitX = _x1 + _t*_dX;
        if ((_hitX < _xMin) || (_hitX > _xMax))
        {
            return [];
        }
        
        var _hitY = _y1 + _t*_dY;
        if ((_hitY < _yMin) || (_hitY >= _yMax))
        {
            return [];
        }
        
        var _hitZ = _z1 + _t*_dZ;
        if ((_hitZ < _zMin) || (_hitZ >= _zMax))
        {
            return [];
        }
        
        var _clampedX1 = _x1 + _tMin*_dX;
        var _clampedY1 = _y1 + _tMin*_dY;
        var _clampedZ1 = _z1 + _tMin*_dZ;
        
        var _clampedX2 = _x1 + _tMax*_dX;
        var _clampedY2 = _y1 + _tMax*_dY;
        var _clampedZ2 = _z1 + _tMax*_dZ;
        
        return __BonkSupercover(_clampedX1/_cellXSize, _clampedY1/_cellYSize, _clampedZ1/_cellZSize,
                                _clampedX2/_cellXSize, _clampedY2/_cellYSize, _clampedZ2/_cellZSize);
    }
}