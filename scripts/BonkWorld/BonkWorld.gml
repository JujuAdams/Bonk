// Feather disable all

/// Constructor to make a struct that organizes a large group of Bonk shapes into a 3D grid for
/// quick collision queries.
/// 
/// `.Add(shape)`
///     Adds the shape permanently to the "world".
/// 
/// `.PointInside(x, y, z)`
///     Returns whether the given point in space is inside the world's axis-aligned bounding box.
/// 
/// `.CellInside(x, y, z)`
///     Returns whether the given cell is inside the world's axis-aligned bounding box.
/// 
/// `.Collide(subjectShape)`
///     Returns the vector that separates the subject shape from any collision in the target world.
///     This method returns a struct that contains the following variables:
///     
///     `.collision`
///         Whether a collision was found. If no collision is found, this variable is set to `false`.
///     
///     `.x` `.y` `.z`
///         The vector that separates the two shapes. If there is no collision, all three variables
///         will be set to `0`.
/// 
///     N.B. The returned struct is statically allocated. Reusing `.Collide()` may cause the same struct
///          to be returned.
/// 
/// `.PushOut(subjectShape, [slopeThreshold=0])`
///     Pushes the subject shape out of the shapes added to the world. The slope threshold will
///     allow shapes to "stand" on slopes instead of sliding down them. The units of this parameter
///     are degrees. An angle of `0` represents a perfectly horizontal floor plane. Increase this
///     value to allow shapes to stand on steeper slopes.
/// 
/// `.GetShapeArrayFromPoint(x, y, z)`
///     Returns an array that contains shapes that may overlap with the specified point.
/// 
/// `.GetShapeArrayFromCell(x, y, z)`
///     Returns an array that contains shapes that may overlap with the specified cell.
/// 
/// `.AddVertexBuffer(vertexBufferOrArray, vertexFormat, [matrix])`
///     Adds triangles from a vertex buffer as collidable shapes to the world. The vertex buffer
///     must be formatted as a triangle list (`pr_trianglelist`). You may provide an array of
///     vertex buffers instead of a single vertex buffer. You may provide a matrix to transform
///     vertices.
///     
///     N.B.  This method is slow in itself and, in general, you should avoid mesh collisions as
///           much as possible because collisions with triangles is also slow.
/// 
/// `.Draw([wireframe])`
///     Draws all shapes added to the world. This uses Ugg, please see https://github.com/jujuadams/Ugg
///     
///     N.B.  This method should only be used for debugging.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkWorld(_xCenter, _yCenter, _zCenter, _cellXSize, _cellYSize, _cellZSize) constructor
{
    static bonkType = BONK_TYPE_WORLD;
    static lineHitFunction = BonkLineHitWorld;
    
    __xCenter = _xCenter;
    __yCenter = _yCenter;
    __zCenter = _zCenter;
    
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
    
    
    
    static __SetPositionFree = function() {}
    static __SetPositionInWorld = function() {}
    
    SetPosition = __SetPositionFree;
    
    static CellInside = function(_x, _y, _z)
    {
        return ((_x >= __minCellX) && (_x <= __maxCellX)
             && (_y >= __minCellY) && (_y <= __maxCellY)
             && (_z >= __minCellZ) && (_z <= __maxCellZ));
    }
    
    static Collide = function(_subjectShape)
    {
        static _map = ds_map_create();
        static _nullCollisionReaction = __Bonk().__nullCollisionReaction;
        
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
                var _reaction = _shapeArray[_i].Collide(_subjectShape);
                if (_reaction.collision)
                {
                    return _reaction;
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.x1 / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.y1 / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.z1 / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.x2 / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.y2 / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.z2 / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
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
                                
                                var _reaction = _shape.Collide(_subjectShape);
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
        
        return _nullCollisionReaction;
    }
    
    static PushOut = function(_subjectShape, _slopeThreshold = 0)
    {
        static _map = ds_map_create();
        static _nullPushOutReaction = __Bonk().__nullPushOutReaction;
        
        var _returnReaction = _nullPushOutReaction;
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
                var _reaction = _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
                if (_reaction.pushOutType != BONK_PUSH_OUT_NONE)
                {
                    with(_reaction.collisionReaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.pushOutType >= _returnReaction.pushOutType))
                        {
                            _largestDepth = _depth;
                            _returnReaction = _reaction.Clone();
                        }
                    }
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.x1 / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.y1 / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.z1 / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.x2 / __cellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.y2 / __cellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.z2 / __cellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
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
                                
                                var _reaction = _shape.PushOut(_subjectShape, _slopeThreshold);
                                if (_reaction.pushOutType != BONK_PUSH_OUT_NONE)
                                {
                                    with(_reaction.collisionReaction)
                                    {
                                        var _depth = dX*dX + dY*dY + dZ*dZ;
                                        if ((_depth > _largestDepth) && (_reaction.pushOutType >= _returnReaction.pushOutType))
                                        {
                                            _largestDepth = _depth;
                                            _returnReaction = _reaction.Clone();
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
        
        return _returnReaction;
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
    
    static __RemoveShape = function(_shape)
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
    
    static __MoveShape = function(_dX, _dY, _dZ, _shape)
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
    
    static GetShapeArrayFromPoint = function(_x, _y, _z)
    {
        return GetShapeArrayFromCell((_x - __xCenter) / __cellXSize,
                                     (_y - __yCenter) / __cellYSize,
                                     (_z - __zCenter) / __cellZSize);
    }
    
    static GetShapeArrayFromCell = function(_x, _y, _z)
    {
        static _emptyArray = [];
        
        _x = floor(clamp(_x, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _y = floor(clamp(_y, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _z = floor(clamp(_z, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        
        return struct_get_from_hash(__spatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    static __GetShapeArrayFromCellUnsafe = function(_x, _y, _z)
    {
        static _emptyArray = [];
        return struct_get_from_hash(__spatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    static __EnsureShapeArrayFromCell = function(_x, _y, _z)
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
    
    static AddVertexBuffer = function(_vertexBufferArray, _vertexFormat, _matrix = undefined)
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
                    
                    var _bonkTri = new BonkTriangle(_a[0], _a[1], _a[2],
                                                    _b[0], _b[1], _b[2],
                                                    _c[0], _c[1], _c[2]);
                }
                else
                {
                    var _bonkTri = new BonkTriangle(_x1, _y1, _z1,
                                                    _x2, _y2, _z2,
                                                    _x3, _y3, _z3);
                }
                
                Add(_bonkTri);
            }
            
            buffer_delete(_buffer);
            
            ++_i;
        }
    }
    
    static Draw = function(_wireframe = undefined)
    {
        static _map = ds_map_create();
        
        var _z = __minCellZ;
        repeat(1 + __maxCellZ - __minCellZ)
        {
            var _y = __minCellY;
            repeat(1 + __maxCellY - __minCellY)
            {
                var _x = __minCellX;
                repeat(1 + __maxCellX - __minCellX)
                {
                    var _shapeArray = __GetShapeArrayFromCellUnsafe(_x, _y, _z);
                        
                    var _i = 0;
                    repeat(array_length(_shapeArray))
                    {
                        var _shape = _shapeArray[_i];
                        if (not ds_map_exists(_map, _shape))
                        {
                            _map[? _shape] = true;    
                            _shape.Draw(undefined, _wireframe);
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