// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize)
{
    bonkType = BONK_TYPE_WORLD;
    bonkGroup = -1;
    
    
    
    __bonkCellXSize = _cellXSize;
    __bonkCellYSize = _cellYSize;
    __bonkCellZSize = _cellZSize;
    
    __bonkMinCellX = 0;
    __bonkMaxCellX = 0;
    __bonkMinCellY = 0;
    __bonkMaxCellY = 0;
    __bonkMinCellZ = 0;
    __bonkMaxCellZ = 0;
    
    __bonkSpatialDict = {};
    
    __bonkWorkerArray = [];
    
    
    
    SetPosition = function() {};
    AddPosition = function() {};
    
    LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        return BonkLineHitWorld(self, _x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _struct);
    }
    
    Touch = function(_subjectShape, _groupFilter = -1)
    {
        static _map = ds_map_create();
        
        var _cheapVersion = true;
        
        var _aabb = _subjectShape.GetAABB();
        with(_aabb)
        {
            if ((xMax - xMin > 2*other.__bonkCellXSize) || (yMax - yMin > 2*other.__bonkCellYSize) || (zMax - zMin > 2*other.__bonkCellZSize))
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
            var _cellX = clamp(floor(_aabb.xMin / __bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.yMin / __bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.zMin / __bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.xMax / __bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.yMax / __bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.zMax / __bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
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
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1, _struct = undefined)
    {
        static _map = ds_map_create();
        
        static _staticDeflectA = new BonkResultDeflect();
        static _staticDeflectB = new BonkResultDeflect();
        
        var _returnDeflect  = _staticDeflectA;
        var _workingDeflect = _staticDeflectB;
        
        var _largestDepth = -infinity;
        
        var _cheapVersion = true;
        var _aabb = _subjectShape.GetAABB();
        with(_aabb)
        {
            if ((xMax - xMin > 2*other.__bonkCellXSize) || (yMax - yMin > 2*other.__bonkCellYSize) || (zMax - zMin > 2*other.__bonkCellZSize))
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
                var _reaction = _shapeArray[_i].Deflect(_subjectShape, _slopeThreshold, _groupFilter, _workingDeflect);
                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        
                        if ((_reaction.deflectType > _returnDeflect.deflectType)
                        ||  ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType)))
                        {
                            _largestDepth = _depth;
                            
                            //Swap over
                            var _tempDeflect = _workingDeflect;
                            _workingDeflect = _returnDeflect;
                            _returnDeflect  = _tempDeflect;
                        }
                    }
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.xMin / __bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.yMin / __bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.zMin / __bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.xMax / __bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.yMax / __bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.zMax / __bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
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
                                
                                var _reaction = _shape.Deflect(_subjectShape, _slopeThreshold, _groupFilter, _workingDeflect);
                                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                                {
                                    with(_reaction.collisionData)
                                    {
                                        var _depth = dX*dX + dY*dY + dZ*dZ;
                                        
                                        if ((_reaction.deflectType > _returnDeflect.deflectType)
                                        ||  ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType)))
                                        {
                                            _largestDepth = _depth;
                                            
                                            //Swap over
                                            var _tempDeflect = _workingDeflect;
                                            _workingDeflect = _returnDeflect;
                                            _returnDeflect  = _tempDeflect;
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
        
        if (_struct == undefined)
        {
            return is_infinity(_largestDepth)? _returnDeflect.__Null() : _returnDeflect;
        }
        else
        {
            return is_infinity(_largestDepth)? _struct.__Null() : _returnDeflect.__CopyTo(_struct);
        }
    }
    
    Collide = function(_subjectShape, _groupFilter = -1, _struct = undefined)
    {
        static _map = ds_map_create();
        static _nullCollisionData = new BonkResultCollide();
        
        var _cheapVersion = true;
        
        var _aabb = _subjectShape.GetAABB();
        with(_aabb)
        {
            if ((xMax - xMin > 2*other.__bonkCellXSize) || (yMax - yMin > 2*other.__bonkCellYSize) || (zMax - zMin > 2*other.__bonkCellZSize))
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
                var _reaction = _shapeArray[_i].Collide(_subjectShape, _groupFilter, _struct);
                if (_reaction.shape != undefined)
                {
                    return _reaction;
                }
                
                ++_i;
            }
        }
        else
        {
            var _cellX = clamp(floor(_aabb.xMin / __bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellY = clamp(floor(_aabb.yMin / __bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZ = clamp(floor(_aabb.zMin / __bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(floor(_aabb.xMax / __bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
            var _cellYSize = 1 + clamp(floor(_aabb.yMax / __bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
            var _cellZSize = 1 + clamp(floor(_aabb.zMax / __bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
            
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
                                
                                var _reaction = _shape.Collide(_subjectShape, _groupFilter, _struct);
                                if (_reaction.shape != undefined)
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
        
        return (_struct == undefined)? _nullCollisionData : _struct.__Null();
    }
    
    FilterTest = function()
    {
        return true;
    }
    
    CellInside = function(_x, _y, _z)
    {
        return ((_x >= __bonkMinCellX) && (_x <= __bonkMaxCellX)
             && (_y >= __bonkMinCellY) && (_y <= __bonkMaxCellY)
             && (_z >= __bonkMinCellZ) && (_z <= __bonkMaxCellZ));
    }
    
    GetAABB = function()
    {
        return {
            xMin: __bonkCellXSize*__bonkMinCellX,
            yMin: __bonkCellYSize*__bonkMinCellY,
            zMin: __bonkCellZSize*__bonkMinCellZ,
            xMax: __bonkCellXSize*(__bonkMaxCellX+1),
            yMax: __bonkCellYSize*(__bonkMaxCellY+1),
            zMax: __bonkCellZSize*(__bonkMaxCellZ+1),
        };
    }
    
    Add = function(_shape)
    {
        if (is_handle(_shape))
        {
            if (BONK_STRICT)
            {
                __BonkError("Cannot add instances to a Bonk world. Please use Bonk structs instead");
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
                __BonkError("Cannot add instances to a Bonk world. Please use Bonk structs instead");
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
        
        var _cellX = clamp(floor((_aabb.xMin / __bonkCellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY = clamp(floor((_aabb.yMin / __bonkCellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ = clamp(floor((_aabb.zMin / __bonkCellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellX2 = clamp(floor((_aabb.xMax / __bonkCellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY2 = clamp(floor((_aabb.yMax / __bonkCellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ2 = clamp(floor((_aabb.zMax / __bonkCellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        __bonkMinCellX = min(__bonkMinCellX, _cellX, _cellX2);
        __bonkMaxCellX = max(__bonkMaxCellX, _cellX, _cellX2);
        __bonkMinCellY = min(__bonkMinCellY, _cellY, _cellY2);
        __bonkMaxCellY = max(__bonkMaxCellY, _cellY, _cellY2);
        __bonkMinCellZ = min(__bonkMinCellZ, _cellZ, _cellZ2);
        __bonkMaxCellZ = max(__bonkMaxCellZ, _cellZ, _cellZ2);
        
        if (__BonkIsInstance()) //TODO - Optimize
        {
            var _left   = __bonkCellXSize*__bonkMinCellX;
            var _top    = __bonkCellYSize*__bonkMinCellY;
            var _right  = __bonkCellXSize*__bonkMaxCellX;
            var _bottom = __bonkCellYSize*__bonkMaxCellY;
            
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
        
        var _cellX = clamp(floor((_aabb.xMin / __bonkCellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY = clamp(floor((_aabb.yMin / __bonkCellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ = clamp(floor((_aabb.zMin / __bonkCellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellXSize = 1 + clamp(floor((_aabb.xMax / __bonkCellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.yMax / __bonkCellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.zMax / __bonkCellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
        
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
        
        var _cellX = clamp(floor((_aabb.xMin / __bonkCellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY = clamp(floor((_aabb.yMin / __bonkCellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ = clamp(floor((_aabb.zMin / __bonkCellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellXSize = 1 + clamp(floor((_aabb.xMax / __bonkCellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.yMax / __bonkCellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.zMax / __bonkCellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
        
        with(_aabb)
        {
            xMin += _dX;
            yMin += _dY;
            zMin += _dZ;
            
            xMax += _dX;
            yMax += _dY;
            zMax += _dZ;
        }
        
        var _cellX2 = clamp(floor((_aabb.xMin / __bonkCellXSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellY2 = clamp(floor((_aabb.yMin / __bonkCellYSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        var _cellZ2 = clamp(floor((_aabb.zMin / __bonkCellZSize) - 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
        
        var _cellXSize2 = 1 + clamp(floor((_aabb.xMax / __bonkCellXSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellX;
        var _cellYSize2 = 1 + clamp(floor((_aabb.yMax / __bonkCellYSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellY;
        var _cellZSize2 = 1 + clamp(floor((_aabb.zMax / __bonkCellZSize) + 0.5), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _cellZ;
        
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
        
        __bonkMinCellX = min(__bonkMinCellX, _cellX, _cellX + _cellXSize - 1);
        __bonkMaxCellX = max(__bonkMaxCellX, _cellX, _cellX + _cellXSize - 1);
        __bonkMinCellY = min(__bonkMinCellY, _cellY, _cellY + _cellYSize - 1);
        __bonkMaxCellY = max(__bonkMaxCellY, _cellY, _cellY + _cellYSize - 1);
        __bonkMinCellZ = min(__bonkMinCellZ, _cellZ, _cellZ + _cellZSize - 1);
        __bonkMaxCellZ = max(__bonkMaxCellZ, _cellZ, _cellZ + _cellZSize - 1);
        
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
        return GetShapeArrayFromCell(_x / __bonkCellXSize, _y / __bonkCellYSize, _z / __bonkCellZSize);
    }
    
    GetShapeArrayFromCell = function(_x, _y, _z)
    {
        static _emptyArray = [];
        
        _x = floor(clamp(_x, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _y = floor(clamp(_y, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _z = floor(clamp(_z, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        
        return struct_get_from_hash(__bonkSpatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    __GetShapeArrayFromCellUnsafe = function(_x, _y, _z)
    {
        static _emptyArray = [];
        return struct_get_from_hash(__bonkSpatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    __EnsureShapeArrayFromCell = function(_x, _y, _z)
    {
        var _key = (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22);
        
        var _array = struct_get_from_hash(__bonkSpatialDict, _key);
        if (_array == undefined)
        {
            _array = [];
            struct_set_from_hash(__bonkSpatialDict, _key, _array);
        }
        
        return _array;
    }
    
    AddVertexBuffer = function(_vertexBufferArray, _vertexFormat, _matrix = undefined)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassWorker(self, _vertexBufferArray, _vertexFormat, _matrix);
        _worker.Force();
        
        return self;
    }
    
    AddVertexBufferAsync = function(_vertexBufferArray, _vertexFormat, _matrix = undefined, _budget = 12)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        return (new __BonkClassWorker(self, _vertexBufferArray, _vertexFormat, _matrix)).__StartAsync(_budget);
    }
    
    GetVertexBufferAsyncCount = function()
    {
        return array_length(__bonkWorkerArray);
    }
    
    CancelVertexBufferAsync = function()
    {
        var _i = array_length(__bonkWorkerArray)-1;
        repeat(array_length(__bonkWorkerArray))
        {
            __bonkWorkerArray[_i].Cancel();
            --_i;
        }
        
        return self;
    }
    
    DrawAABB = function(_color = undefined, _wireframe = true)
    {
        __BONK_VERIFY_UGG
        
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
        
        var _xMin = floor(clamp(_struct.xMin / __bonkCellXSize, __bonkMinCellX, __bonkMaxCellX));
        var _yMin = floor(clamp(_struct.yMin / __bonkCellYSize, __bonkMinCellY, __bonkMaxCellY));
        var _zMin = floor(clamp(_struct.zMin / __bonkCellZSize, __bonkMinCellZ, __bonkMaxCellZ));
        var _xMax = floor(clamp(_struct.xMax / __bonkCellXSize, __bonkMinCellX, __bonkMaxCellX));
        var _yMax = floor(clamp(_struct.yMax / __bonkCellYSize, __bonkMinCellY, __bonkMaxCellY));
        var _zMax = floor(clamp(_struct.zMax / __bonkCellZSize, __bonkMinCellZ, __bonkMaxCellZ));
        
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
                            _shape.DebugDraw(_color, _wireframe);
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
        
        var _minCellX = __bonkMinCellX;
        var _maxCellX = __bonkMaxCellX;
        var _minCellY = __bonkMinCellY;
        var _maxCellY = __bonkMaxCellY;
        var _minCellZ = __bonkMinCellZ;
        var _maxCellZ = __bonkMaxCellZ;
        
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
                    _shape.DebugDraw(_color, _wireframe);
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
        var _cellXSize = __bonkCellXSize;
        var _cellYSize = __bonkCellYSize;
        var _cellZSize = __bonkCellZSize;
        
        var _minCellX = __bonkMinCellX;
        var _maxCellX = __bonkMaxCellX;
        var _minCellY = __bonkMinCellY;
        var _maxCellY = __bonkMaxCellY;
        var _minCellZ = __bonkMinCellZ;
        var _maxCellZ = __bonkMaxCellZ;
        
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
        var _cellXSize = __bonkCellXSize;
        var _cellYSize = __bonkCellYSize;
        var _cellZSize = __bonkCellZSize;
        
        var _xMin = floor(clamp(_struct.xMin / _cellXSize, __bonkMinCellX, __bonkMaxCellX));
        var _yMin = floor(clamp(_struct.yMin / _cellYSize, __bonkMinCellY, __bonkMaxCellY));
        var _zMin = floor(clamp(_struct.zMin / _cellZSize, __bonkMinCellZ, __bonkMaxCellZ));
        var _xMax = floor(clamp(_struct.xMax / _cellXSize, __bonkMinCellX, __bonkMaxCellX));
        var _yMax = floor(clamp(_struct.yMax / _cellYSize, __bonkMinCellY, __bonkMaxCellY));
        var _zMax = floor(clamp(_struct.zMax / _cellZSize, __bonkMinCellZ, __bonkMaxCellZ));
        
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
    
    DrawNeighborhoodForRange = function(_aabb, _color)
    {
        DrawCellsFromRange(_aabb);
        
        var _oldEnable = gpu_get_ztestenable();
        var _oldWrite = gpu_get_zwriteenable();
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        
        DrawShapesFromRange(_aabb, _color, true);
        
        gpu_set_ztestenable(_oldEnable);
        gpu_set_zwriteenable(_oldWrite);
        
        return self;
    }
    
    DrawNeighborhoodForArray = function(_array, _color)
    {
        DrawCellsFromArray(_array);
        
        var _oldEnable = gpu_get_ztestenable();
        var _oldWrite = gpu_get_zwriteenable();
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        
        DrawShapesFromArray(_array, _color, true);
        
        gpu_set_ztestenable(_oldEnable);
        gpu_set_zwriteenable(_oldWrite);
        
        return self;
    }
    
    DrawNeighborhoodForShape = function(_shape, _color)
    {
        DrawNeighborhoodForRange(_shape.GetAABB(), _color);
        
        return self;
    }
    
    DrawNeighborhoodForLine = function(_lineShape, _color)
    {
        DrawNeighborhoodForArray(GetCellsFromLine(_lineShape), _color);
        
        return self;
    }
    
    DrawNeighborhoodForLineExt = function(_x1, _y1, _z1, _x2, _y2, _z2, _color)
    {
        DrawNeighborhoodForArray(GetCellsFromLineExt(_x1, _y1, _z1, _x2, _y2, _z2), _color);
        
        return self;
    }
    
    GetCellsFromLine = function(_lineShape)
    {
        with(_lineShape)
        {
            if (bonkType == BONK_TYPE_LINE)
            {
                return other.GetCellsFromLineExt(x1, y1, z1,   x2, y2, z2);
            }
            else if (bonkType == BONK_TYPE_RAY)
            {
                return other.GetCellsFromLineExt(x, y, z,   x + BONK_RAY_LENGTH*dx, y + BONK_RAY_LENGTH*dy, z + BONK_RAY_LENGTH*dz);
            }
            else
            {
                __BonkError($"Can only get cells for shapes that are a line or a ray (type was {bonkType})");
            }
        }
        
        return [];
    }
    
    GetCellsFromLineExt = function(_x1, _y1, _z1, _x2, _y2, _z2)
    {
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        //FIXME - Calculate these values when changing bounds
        var _xMin = __bonkMinCellX*__bonkCellXSize;
        var _yMin = __bonkMinCellY*__bonkCellYSize;
        var _zMin = __bonkMinCellZ*__bonkCellZSize;
        var _xMax = (__bonkMaxCellX+1)*__bonkCellXSize;
        var _yMax = (__bonkMaxCellY+1)*__bonkCellYSize;
        var _zMax = (__bonkMaxCellZ+1)*__bonkCellZSize;
        
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
        
        var _cellXSize = __bonkCellXSize;
        var _cellYSize = __bonkCellYSize;
        var _cellZSize = __bonkCellZSize;
        
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