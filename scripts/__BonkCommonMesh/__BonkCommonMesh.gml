// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function __BonkCommonMesh(_cellXSize, _cellYSize, _cellZSize)
{
    bonkType = BONK_TYPE_MESH;
    __bonkWorld = undefined;
    bonkGroup = -1;
    
    
    
    __bonkCellXSize = _cellXSize;
    __bonkCellYSize = _cellYSize;
    __bonkCellZSize = _cellZSize;
    
    __bonkMinCellX = 0;
    __bonkMinCellY = 0;
    __bonkMinCellZ = 0;
    
    __bonkMaxCellX = 0;
    __bonkMaxCellY = 0;
    __bonkMaxCellZ = 0;
    
    __bonkSpatialDict = {};
    
    __bonkWorkerArray = [];
    
    __bonkMatrix = matrix_build_identity();
    __bonkSetMatrix = false;
    
    
    //These are not available and don't do anything. Users should move meshes by setting the
    //transformation matrix
    SetPosition          = function() {};
    __SetPositionInWorld = function() {};
    __SetPositionFree    = function() {};
    AddPosition          = function() {};
    
    SetMatrix = function(_matrix)
    {
        static _map = ds_map_create();
        
        __bonkSetMatrix = true;
        
        if (array_equals(__bonkMatrix, _matrix)) return;
        
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__RemoveShape(self);
        }
        
        var _transformMatrix = matrix_multiply(matrix_inverse(__bonkMatrix), _matrix);
        array_copy(__bonkMatrix, 0, _matrix, 0, 16);
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _cellXSize = 1 + _maxCellX - _minCellX;
        var _cellYSize = 1 + _maxCellY - _minCellY;
        var _cellZSize = 1 + _maxCellZ - _minCellZ;
        
        ds_map_clear(_map);
        var _triangleArray = [];
        
        //This is way, way faster than `struct_foreach()`
        var _z = _minCellZ;
        repeat(_cellZSize)
        {
            var _y = _minCellY;
            repeat(_cellYSize)
            {
                var _x = _minCellX;
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
                            array_push(_triangleArray, _shape);
                        }
                        
                        ++_i;
                    }
                    
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
        
        __bonkSpatialDict = {};
        
        var _bonkCellXSize = __bonkCellXSize;
        var _bonkCellYSize = __bonkCellYSize;
        var _bonkCellZSize = __bonkCellZSize;
        
        var _meshMinCellX = infinity;
        var _meshMinCellY = infinity;
        var _meshMinCellZ = infinity;
        
        var _meshMaxCellX = -infinity;
        var _meshMaxCellY = -infinity;
        var _meshMaxCellZ = -infinity;
        
        var _mesh = self;
        var _vector = array_create(4, 0);
        var _i = 0;
        repeat(array_length(_triangleArray))
        {
            with(_triangleArray[_i])
            {
                matrix_transform_vertex(_transformMatrix, x1, y1, z1, 1, _vector);
                x1 = _vector[0]; y1 = _vector[1]; z1 = _vector[2];
                
                matrix_transform_vertex(_transformMatrix, x2, y2, z2, 1, _vector);
                x2 = _vector[0]; y2 = _vector[1]; z2 = _vector[2];
                
                matrix_transform_vertex(_transformMatrix, x3, y3, z3, 1, _vector);
                x3 = _vector[0]; y3 = _vector[1]; z3 = _vector[2];
                
                Refresh();
                
                var _aabb = GetAABB();
                
                var _cellXMin = clamp(floor(_aabb.xMin / _bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                var _cellYMin = clamp(floor(_aabb.yMin / _bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                var _cellZMin = clamp(floor(_aabb.zMin / _bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                
                var _cellXMax = clamp(floor(_aabb.xMax / _bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                var _cellYMax = clamp(floor(_aabb.yMax / _bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                var _cellZMax = clamp(floor(_aabb.zMax / _bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                
                _meshMinCellX = min(_meshMinCellX, _cellXMin, _cellXMax);
                _meshMinCellY = min(_meshMinCellY, _cellYMin, _cellYMax);
                _meshMinCellZ = min(_meshMinCellZ, _cellZMin, _cellZMax);
            
                _meshMaxCellX = max(_meshMaxCellX, _cellXMin, _cellXMax);
                _meshMaxCellY = max(_meshMaxCellY, _cellYMin, _cellYMax);
                _meshMaxCellZ = max(_meshMaxCellZ, _cellZMin, _cellZMax);
                
                var _cellXSize = 1 + _cellXMax - _cellXMin;
                var _cellYSize = 1 + _cellYMax - _cellYMin;
                var _cellZSize = 1 + _cellZMax - _cellZMin;
                
                var _z = _cellZMin;
                repeat(_cellZSize)
                {
                    var _y = _cellYMin;
                    repeat(_cellYSize)
                    {
                        var _x = _cellXMin;
                        repeat(_cellXSize)
                        {
                            array_push(_mesh.__EnsureShapeArrayFromCell(_x, _y, _z), self);
                            ++_x;
                        }
                        
                        ++_y;
                    }
                    
                    ++_z;
                }
            }
            
            ++_i;
        }
        
        if (is_infinity(_meshMinCellX))
        {
            __bonkMinCellX = 0;
            __bonkMinCellY = 0;
            __bonkMinCellZ = 0;
            
            __bonkMaxCellX = 0;
            __bonkMaxCellY = 0;
            __bonkMaxCellZ = 0;
        }
        else
        {
            __bonkMinCellX = _meshMinCellX;
            __bonkMinCellY = _meshMinCellY;
            __bonkMinCellZ = _meshMinCellZ;
            
            __bonkMaxCellX = _meshMaxCellX;
            __bonkMaxCellY = _meshMaxCellY;
            __bonkMaxCellZ = _meshMaxCellZ;
        }
        
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__AddShape(self);
        }
        
        return self;
    };
    
    GetMatrix = function()
    {
        return __bonkMatrix;
    };
    
    LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        return BonkLineHitMesh(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct, _groupFilter);
    }
    
    Touch = function(_subjectShape, _groupFilter = -1)
    {
        static _map = ds_map_create();
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _aabb = _subjectShape.GetAABB();
        
        var _shapeXMin = floor(_aabb.xMin / __bonkCellXSize);
        var _shapeYMin = floor(_aabb.yMin / __bonkCellYSize);
        var _shapeZMin = floor(_aabb.zMin / __bonkCellZSize);
        
        var _shapeXMax = floor(_aabb.xMax / __bonkCellXSize);
        var _shapeYMax = floor(_aabb.yMax / __bonkCellYSize);
        var _shapeZMax = floor(_aabb.zMax / __bonkCellZSize);
        
        if ((_shapeXMin > _maxCellX) || (_shapeYMin > _maxCellY) || (_shapeZMin > _maxCellZ)
        ||  (_shapeXMax < _minCellX) || (_shapeYMax < _minCellY) || (_shapeZMax < _minCellZ))
        {
            //Shape is outside bounds
            return false;
        }
        
        _shapeXMin = clamp(_shapeXMin, _minCellX, _maxCellX);
        _shapeYMin = clamp(_shapeYMin, _minCellY, _maxCellY);
        _shapeZMin = clamp(_shapeZMin, _minCellZ, _maxCellZ);
        
        _shapeXMax = clamp(_shapeXMax, _minCellX, _maxCellX);
        _shapeYMax = clamp(_shapeYMax, _minCellY, _maxCellY);
        _shapeZMax = clamp(_shapeZMax, _minCellZ, _maxCellZ);
        
        if ((_shapeXMin == _shapeXMax) && (_shapeYMin == _shapeYMax) && (_shapeZMin == _shapeZMax))
        {
            var _shapeArray = GetShapeArrayFromCell(_shapeXMin, _shapeYMin, _shapeZMin);
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                if (_shapeArray[_i].Touch(_subjectShape, _groupFilter, true))
                {
                    return true;
                }
                
                ++_i;
            }
        }
        else
        {
            _shapeXMin = clamp(_shapeXMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            _shapeYMin = clamp(_shapeYMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            _shapeZMin = clamp(_shapeZMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXSize = 1 + clamp(_shapeXMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeXMin;
            var _cellYSize = 1 + clamp(_shapeYMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeYMin;
            var _cellZSize = 1 + clamp(_shapeZMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeZMin;
            
            var _z = _shapeZMin;
            repeat(_cellZSize)
            {
                var _y = _shapeYMin;
                repeat(_cellYSize)
                {
                    var _x = _shapeXMin;
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
    
    Collide = function(_subjectShape, _groupFilter = -1, _struct = undefined)
    {
        static _map = ds_map_create();
        static _nullCollisionData = new BonkResultCollide();
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _aabb = _subjectShape.GetAABB();
        
        var _shapeXMin = floor(_aabb.xMin / __bonkCellXSize);
        var _shapeYMin = floor(_aabb.yMin / __bonkCellYSize);
        var _shapeZMin = floor(_aabb.zMin / __bonkCellZSize);
        
        var _shapeXMax = floor(_aabb.xMax / __bonkCellXSize);
        var _shapeYMax = floor(_aabb.yMax / __bonkCellYSize);
        var _shapeZMax = floor(_aabb.zMax / __bonkCellZSize);
        
        if ((_shapeXMin > _maxCellX) || (_shapeYMin > _maxCellY) || (_shapeZMin > _maxCellZ)
        ||  (_shapeXMax < _minCellX) || (_shapeYMax < _minCellY) || (_shapeZMax < _minCellZ))
        {
            //Shape is outside bounds
            return _nullCollisionData;
        }
        else
        {
            _shapeXMin = clamp(_shapeXMin, _minCellX, _maxCellX);
            _shapeYMin = clamp(_shapeYMin, _minCellY, _maxCellY);
            _shapeZMin = clamp(_shapeZMin, _minCellZ, _maxCellZ);
            
            _shapeXMax = clamp(_shapeXMax, _minCellX, _maxCellX);
            _shapeYMax = clamp(_shapeYMax, _minCellY, _maxCellY);
            _shapeZMax = clamp(_shapeZMax, _minCellZ, _maxCellZ);
            
            if ((_shapeXMin == _shapeXMax) && (_shapeYMin == _shapeYMax) && (_shapeZMin == _shapeZMax))
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
                _shapeXMin = clamp(_shapeXMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                _shapeYMin = clamp(_shapeYMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                _shapeZMin = clamp(_shapeZMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                
                var _cellXSize = 1 + clamp(_shapeXMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeXMin;
                var _cellYSize = 1 + clamp(_shapeYMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeYMin;
                var _cellZSize = 1 + clamp(_shapeZMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeZMin;
                
                var _z = _shapeZMin;
                repeat(_cellZSize)
                {
                    var _y = _shapeYMin;
                    repeat(_cellYSize)
                    {
                        var _x = _shapeXMin;
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
                                    
                                    //TODO - Call triangle collision code directly
                                    
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
        }
        
        return (_struct == undefined)? _nullCollisionData : _struct.Null();
    }
    
    __CollideAddToArray = function(_collideArrayContainer, _subjectShape, _groupFilter)
    {
        static _map = ds_map_create();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            var _minCellX = __bonkMinCellX;
            var _minCellY = __bonkMinCellY;
            var _minCellZ = __bonkMinCellZ;
            
            var _maxCellX = __bonkMaxCellX;
            var _maxCellY = __bonkMaxCellY;
            var _maxCellZ = __bonkMaxCellZ;
            
            var _aabb = _subjectShape.GetAABB();
            
            var _shapeXMin = floor(_aabb.xMin / __bonkCellXSize);
            var _shapeYMin = floor(_aabb.yMin / __bonkCellYSize);
            var _shapeZMin = floor(_aabb.zMin / __bonkCellZSize);
            
            var _shapeXMax = floor(_aabb.xMax / __bonkCellXSize);
            var _shapeYMax = floor(_aabb.yMax / __bonkCellYSize);
            var _shapeZMax = floor(_aabb.zMax / __bonkCellZSize);
            
            if ((_shapeXMin > _maxCellX) || (_shapeYMin > _maxCellY) || (_shapeZMin > _maxCellZ)
            ||  (_shapeXMax < _minCellX) || (_shapeYMax < _minCellY) || (_shapeZMax < _minCellZ))
            {
                //Shape is outside bounds
                return;
            }
            else
            {
                _shapeXMin = clamp(_shapeXMin, _minCellX, _maxCellX);
                _shapeYMin = clamp(_shapeYMin, _minCellY, _maxCellY);
                _shapeZMin = clamp(_shapeZMin, _minCellZ, _maxCellZ);
                
                _shapeXMax = clamp(_shapeXMax, _minCellX, _maxCellX);
                _shapeYMax = clamp(_shapeYMax, _minCellY, _maxCellY);
                _shapeZMax = clamp(_shapeZMax, _minCellZ, _maxCellZ);
                
                if ((_shapeXMin == _shapeXMax) && (_shapeYMin == _shapeYMax) && (_shapeZMin == _shapeZMax))
                {
                    var _shapeArray = GetShapeArrayFromPoint(_subjectShape.x, _subjectShape.y, _subjectShape.z);
                    var _i = 0;
                    repeat(array_length(_shapeArray))
                    {
                        _shapeArray[_i].__CollideAddToArray(_collideArrayContainer, _subjectShape, -1);
                        ++_i;
                    }
                }
                else
                {
                    _shapeXMin = clamp(_shapeXMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                    _shapeYMin = clamp(_shapeYMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                    _shapeZMin = clamp(_shapeZMin, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
                    
                    var _cellXSize = 1 + clamp(_shapeXMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeXMin;
                    var _cellYSize = 1 + clamp(_shapeYMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeYMin;
                    var _cellZSize = 1 + clamp(_shapeZMax, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX) - _shapeZMin;
                    
                    var _z = _shapeZMin;
                    repeat(_cellZSize)
                    {
                        var _y = _shapeYMin;
                        repeat(_cellYSize)
                        {
                            var _x = _shapeXMin;
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
                                        _shape.__CollideAddToArray(_collideArrayContainer, _subjectShape, -1);
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
        }
    }
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1)
    {
        static _staticCollideArrayContainer = new __BonkClassCollideArrayContainer();
        var _collideArrayContainer = _staticCollideArrayContainer;
        
        __CollideAddToArray(_collideArrayContainer, _subjectShape, _groupFilter);
        var _return = __BonkConvertCollideArrayToDeflect(_collideArrayContainer, _subjectShape, _slopeThreshold);
        
        _collideArrayContainer.__count = 0;
        return _return;
    }
    
    FilterTest = function(_filter = -1)
    {
        if (_filter < 0)
        {
            return true;
        }
        
        var _bonkGroup = bonkGroup;
        
        //Filter out shapes that conflict with the NOT vector (if in use)
        var _notVector = (_filter >> 40) & 0xFFFFF;
        if ((_notVector > 0) && (_bonkGroup & _notVector))
        {
            return false;
        }
        
        //Accept shapes that hit the OR vector
        if (_bonkGroup & (_filter & 0xFFFFF))
        {
            return true;
        }
        
        //Accept shapes the hit all of the AND vector (if in use)
        var _andVector = (_filter >> 20) & 0xFFFFF;
        if ((_andVector > 0) && ((_bonkGroup & _andVector) == _andVector))
        {
            return true;
        }
        
        return false;
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
    
    AddVertexBuffer = function(_vertexBufferArray, _vertexFormat, _applySoftEdges = true)
    {
        if (not __bonkSetMatrix)
        {
            __BonkTrace($"Warning! Set the mesh matrix with `.SetMatrix()` before calling `.AddVertexBuffer()`");
        }
        
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassMeshWorker(self, _vertexBufferArray, _vertexFormat, __bonkMatrix, _applySoftEdges);
        _worker.Force();
        
        return self;
    }
    
    AddVertexBufferAsync = function(_vertexBufferArray, _vertexFormat, _budget = 12, _applySoftEdges = true)
    {
        if (not __bonkSetMatrix)
        {
            __BonkTrace($"Warning! Set the mesh matrix with `.SetMatrix()` before calling `.AddVertexBuffer()`");
        }
        
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassMeshWorker(self, _vertexBufferArray, _vertexFormat, __bonkMatrix, _applySoftEdges);
        _worker.__StartAsync();
        
        return _worker;
    }
    
    GetVertexBufferAsyncRemaining = function()
    {
        var _value = 0;
        
        var _i = 0;
        repeat(array_length(__bonkWorkerArray))
        {
            _value += __bonkWorkerArray[_i].GetRemaining();
            ++_i;
        }
        
        return _value;
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
    
    #region Draw
    
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
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _xMin = floor(_struct.xMin / __bonkCellXSize);
        var _yMin = floor(_struct.yMin / __bonkCellYSize);
        var _zMin = floor(_struct.zMin / __bonkCellZSize);
        
        var _xMax = floor(_struct.xMax / __bonkCellXSize);
        var _yMax = floor(_struct.yMax / __bonkCellYSize);
        var _zMax = floor(_struct.zMax / __bonkCellZSize);
        
        if ((_xMin > _maxCellX) || (_yMin > _maxCellY) || (_zMin > _maxCellZ)
        ||  (_xMax < _minCellX) || (_yMax < _minCellY) || (_zMax < _minCellZ))
        {
            //Range is outside bounds
            return;
        }
        
        _xMin = clamp(_xMin, _minCellX, _maxCellX);
        _yMin = clamp(_yMin, _minCellY, _maxCellY);
        _zMin = clamp(_zMin, _minCellZ, _maxCellZ);
        
        _xMax = clamp(_xMax, _minCellX, _maxCellX);
        _yMax = clamp(_yMax, _minCellY, _maxCellY);
        _zMax = clamp(_zMax, _minCellZ, _maxCellZ);
        
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
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
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
    
    DebugDraw = DrawShapes;
    
    DrawCellsFromArray = function(_array, _color = undefined, _wireframe = true)
    {
        var _cellXSize = __bonkCellXSize;
        var _cellYSize = __bonkCellYSize;
        var _cellZSize = __bonkCellZSize;
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
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
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _xMin = floor(_struct.xMin / _cellXSize);
        var _yMin = floor(_struct.yMin / _cellYSize);
        var _zMin = floor(_struct.zMin / _cellZSize);
        
        var _xMax = floor(_struct.xMax / _cellXSize);
        var _yMax = floor(_struct.yMax / _cellYSize);
        var _zMax = floor(_struct.zMax / _cellZSize);
        
        if ((_xMin > _maxCellX) || (_yMin > _maxCellY) || (_zMin > _maxCellZ)
        ||  (_xMax < _minCellX) || (_yMax < _minCellY) || (_zMax < _minCellZ))
        {
            //Range is outside bounds
            return;
        }
        
        _xMin = clamp(_xMin, _minCellX, _maxCellX);
        _yMin = clamp(_yMin, _minCellY, _maxCellY);
        _zMin = clamp(_zMin, _minCellZ, _maxCellZ);
        
        _xMax = clamp(_xMax, _minCellX, _maxCellX);
        _yMax = clamp(_yMax, _minCellY, _maxCellY);
        _zMax = clamp(_zMax, _minCellZ, _maxCellZ);
        
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
    
    #endregion
    
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
                return other.GetCellsFromLineExt(x, y, z,   x + BONK_RAY_LENGTH*dX, y + BONK_RAY_LENGTH*dY, z + BONK_RAY_LENGTH*dZ);
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
        //FIXME - Return a static array
        
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
        if ((_hitY < _yMin) || (_hitY > _yMax))
        {
            return [];
        }
        
        var _hitZ = _z1 + _t*_dZ;
        if ((_hitZ < _zMin) || (_hitZ > _zMax))
        {
            return [];
        }
        
        var _clampedX1 = _x1 + _tMin*_dX;
        var _clampedY1 = _y1 + _tMin*_dY;
        var _clampedZ1 = _z1 + _tMin*_dZ;
        
        var _clampedX2 = _x1 + _tMax*_dX;
        var _clampedY2 = _y1 + _tMax*_dY;
        var _clampedZ2 = _z1 + _tMax*_dZ;
        
        return __BonkSupercover3D(_clampedX1/_cellXSize, _clampedY1/_cellYSize, _clampedZ1/_cellZSize,
                                  _clampedX2/_cellXSize, _clampedY2/_cellYSize, _clampedZ2/_cellZSize);
    }
}