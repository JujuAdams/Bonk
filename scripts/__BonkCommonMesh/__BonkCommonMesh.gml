// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function __BonkCommonMesh(_cellXSize, _cellYSize, _cellZSize)
{
    bonkType = BONK_TYPE_MESH;
    __bonkWorld = undefined;
    bonkGroup = BONK_DEFAULT_GROUP;
    
    __bonkMatrix           = matrix_build_identity();
    __bonkInverseMatrix    = matrix_build_identity();
    __bonkAbsMatrix        = matrix_build_identity();
    __bonkAbsInverseMatrix = matrix_build_identity();
    
    __bonkCellXSize = _cellXSize;
    __bonkCellYSize = _cellYSize;
    __bonkCellZSize = _cellZSize;
    
    __bonkMinCellX = 0;
    __bonkMinCellY = 0;
    __bonkMinCellZ = 0;
    
    __bonkMaxCellX = 0;
    __bonkMaxCellY = 0;
    __bonkMaxCellZ = 0;
    
    __bonkWidth  = 1;
    __bonkHeight = 1;
    
    __bonkSpatialMap = ds_map_create(); //FIXME - Memory leak!
    __bonkTriangleArray = [];
    
    __bonkWorkerArray = [];
    
    //These are not available and don't do anything. Users should move meshes by setting the
    //transformation matrix
    SetPosition          = function() {};
    __SetPositionInWorld = function() {};
    __SetPositionFree    = function() {};
    AddPosition          = function() {};
    
    toString = function()
    {
        return $"<mesh {__bonkMatrix[12]}, {__bonkMatrix[13]}, {__bonkMatrix[14]}>";
    }
    
    SetMatrix = function(_matrix)
    {
        if (array_equals(__bonkMatrix, _matrix)) return;
        
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__RemoveShape(self);
        }
        
        array_copy(__bonkMatrix, 0, _matrix, 0, 16);
        matrix_inverse(__bonkMatrix, __bonkInverseMatrix);
        
        var _absMatrix = __bonkAbsMatrix;
        var _i = 0;
        repeat(16)
        {
            _absMatrix[@ _i] = abs(_matrix[_i]);
            ++_i;
        }
        
        var _inverseMatrix = __bonkInverseMatrix;
        var _absMatrix = __bonkAbsInverseMatrix;
        var _i = 0;
        repeat(16)
        {
            _absMatrix[@ _i] = abs(_inverseMatrix[_i]);
            ++_i;
        }
        
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__AddShape(self);
        }
        
        return self;
    };
    
    GetMatrix = function()
    {
        if (__bonkMatrix == undefined)
        {
            return matrix_build_identity();
        }
        else
        {
            return __bonkMatrix;
        }
    };
    
    GetInverseMatrix = function()
    {
        return __bonkInverseMatrix;
    }
    
    LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = undefined, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            return BonkLineHitMesh(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.Null();
        }
    }
    
    Touch = function(_subjectShape, _groupFilter = undefined)
    {
        static _map = ds_map_create();
        
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            var _minCellX = __bonkMinCellX;
            var _minCellY = __bonkMinCellY;
            var _minCellZ = __bonkMinCellZ;
            
            var _maxCellX = __bonkMaxCellX;
            var _maxCellY = __bonkMaxCellY;
            var _maxCellZ = __bonkMaxCellZ;
            
            var _aabb = GetOtherAABB(_subjectShape.GetAABB());
            
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
                                        _subjectShape.x += x;
                                        _subjectShape.y += y;
                                        _subjectShape.z += z;
                                        
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
        }
        
        return false;
    }
    
    Collide = function(_subjectShape, _groupFilter = undefined, _struct = undefined)
    {
        static _map = ds_map_create();
        static _nullCollisionData = new BonkResultCollide();
        
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            var _minCellX = __bonkMinCellX;
            var _minCellY = __bonkMinCellY;
            var _minCellZ = __bonkMinCellZ;
            
            var _maxCellX = __bonkMaxCellX;
            var _maxCellY = __bonkMaxCellY;
            var _maxCellZ = __bonkMaxCellZ;
            
            var _aabb = GetOtherAABB(_subjectShape.GetAABB());
            
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
        }
        
        return (_struct == undefined)? _nullCollisionData : _struct.Null();
    }
    
    __CollideAddToArray = function(_collideArrayContainer, _subjectShape, _groupFilter)
    {
        static _map = ds_map_create();
        
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            var _minCellX = __bonkMinCellX;
            var _minCellY = __bonkMinCellY;
            var _minCellZ = __bonkMinCellZ;
            
            var _maxCellX = __bonkMaxCellX;
            var _maxCellY = __bonkMaxCellY;
            var _maxCellZ = __bonkMaxCellZ;
            
            var _aabb = GetOtherAABB(_subjectShape.GetAABB());
            
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
                        _shapeArray[_i].__CollideAddToArray(_collideArrayContainer, _subjectShape, undefined);
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
                                        _shape.__CollideAddToArray(_collideArrayContainer, _subjectShape, undefined);
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
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = undefined)
    {
        static _staticCollideArrayContainer = new __BonkClassCollideArrayContainer();
        var _collideArrayContainer = _staticCollideArrayContainer;
        
        __CollideAddToArray(_collideArrayContainer, _subjectShape, _groupFilter);
        var _return = __BonkConvertCollideArrayToDeflect(_collideArrayContainer, _subjectShape, _slopeThreshold);
        
        _collideArrayContainer.__count = 0;
        return _return;
    }
    
    CellInside = function(_x, _y, _z)
    {
        return ((_x >= __bonkMinCellX) && (_x <= __bonkMaxCellX)
             && (_y >= __bonkMinCellY) && (_y <= __bonkMaxCellY)
             && (_z >= __bonkMinCellZ) && (_z <= __bonkMaxCellZ));
    }
    
    GetOtherAABB = function(_struct)
    {
        static _staticVectorMid  = array_create(4, 0);
        static _staticVectorSize = array_create(4, 0);
        var _vectorMid  = _staticVectorMid;
        var _vectorSize = _staticVectorSize;
        
        with(_struct)
        {
            var _xMid = 0.5*(xMin + xMax);
            var _yMid = 0.5*(yMin + yMax);
            var _zMid = 0.5*(zMin + zMax);
            
            var _xSize = 0.5*(xMax - xMin);
            var _ySize = 0.5*(yMax - yMin);
            var _zSize = 0.5*(zMax - zMin);
            
            matrix_transform_vertex(other.__bonkInverseMatrix,    _xMid,  _yMid,  _zMid,  1, _vectorMid);
            matrix_transform_vertex(other.__bonkAbsInverseMatrix, _xSize, _ySize, _zSize, 0, _vectorSize);
            
            xMin = _vectorMid[0] - _vectorSize[0];
            yMin = _vectorMid[1] - _vectorSize[1];
            zMin = _vectorMid[2] - _vectorSize[2];
            
            xMax = _vectorMid[0] + _vectorSize[0];
            yMax = _vectorMid[1] + _vectorSize[1];
            zMax = _vectorMid[2] + _vectorSize[2];
            
            return self;
        }
    }
    
    GetAABB = function()
    {
        //TODO - Calculate these values when setting the shared matrix
        
        static _staticVectorMid  = array_create(4, 0);
        static _staticVectorSize = array_create(4, 0);
        var _vectorMid  = _staticVectorMid;
        var _vectorSize = _staticVectorSize;
        
        var _xMin = __bonkCellXSize*__bonkMinCellX;
        var _yMin = __bonkCellYSize*__bonkMinCellY;
        var _zMin = __bonkCellZSize*__bonkMinCellZ;
        
        var _xMax = __bonkCellXSize*(__bonkMaxCellX+1);
        var _yMax = __bonkCellYSize*(__bonkMaxCellY+1);
        var _zMax = __bonkCellZSize*(__bonkMaxCellZ+1);
        
        var _xMid = 0.5*(_xMin + _xMax);
        var _yMid = 0.5*(_yMin + _yMax);
        var _zMid = 0.5*(_zMin + _zMax);
        
        var _xSize = 0.5*(_xMax - _xMin);
        var _ySize = 0.5*(_yMax - _yMin);
        var _zSize = 0.5*(_zMax - _zMin);
        
        matrix_transform_vertex(__bonkMatrix,    _xMid,  _yMid,  _zMid,  1, _vectorMid);
        matrix_transform_vertex(__bonkAbsMatrix, _xSize, _ySize, _zSize, 0, _vectorSize);
        
        with({})
        {
            xMin = _vectorMid[0] - _vectorSize[0];
            yMin = _vectorMid[1] - _vectorSize[1];
            zMin = _vectorMid[2] - _vectorSize[2];
            
            xMax = _vectorMid[0] + _vectorSize[0];
            yMax = _vectorMid[1] + _vectorSize[1];
            zMax = _vectorMid[2] + _vectorSize[2];
            
            return self;
        }
    }
    
    GetShapeArrayFromPoint = function(_x, _y, _z)
    {
        static _staticVector = array_create(4, 0);
        var _vector = _staticVector;
        
        matrix_transform_vertex(__bonkInverseMatrix, _x, _y, _z, 1, _vector);
        return GetShapeArrayFromCell(_vector[0] / __bonkCellXSize, _vector[1] / __bonkCellYSize, _vector[2] / __bonkCellZSize);
    }
    
    GetShapeArrayFromCell = function(_x, _y, _z)
    {
        static _emptyArray = [];
        
        _x = floor(clamp(_x, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _y = floor(clamp(_y, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _z = floor(clamp(_z, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        
        return __bonkSpatialMap[? (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)] ?? _emptyArray;
    }
    
    __GetShapeArrayFromCellUnsafe = function(_x, _y, _z)
    {
        static _emptyArray = [];
        return __bonkSpatialMap[? (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)] ?? _emptyArray;
    }
    
    __EnsureShapeArrayFromCell = function(_x, _y, _z)
    {
        var _key = (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22);
        
        var _array = __bonkSpatialMap[? _key];
        if (_array == undefined)
        {
            _array = [];
            __bonkSpatialMap[? _key] = _array;
        }
        
        return _array;
    }
    
    AddVertexBuffer = function(_vertexBufferArray, _vertexFormat, _matrix = matrix_build_identity(), _applySoftEdges = true)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassMeshWorker(self, _vertexBufferArray, _vertexFormat, _matrix, _applySoftEdges);
        _worker.Force();
        
        return self;
    }
    
    AddVertexBufferAsync = function(_vertexBufferArray, _vertexFormat, _budget = 12, _matrix = matrix_build_identity(), _applySoftEdges = true)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassMeshWorker(self, _vertexBufferArray, _vertexFormat, _matrix, _applySoftEdges);
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
        
        //TODO - Use matrix transform
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _xMin = floor((_struct.xMin - _xShape) / __bonkCellXSize);
        var _yMin = floor((_struct.yMin - _yShape) / __bonkCellYSize);
        var _zMin = floor((_struct.zMin - _zShape) / __bonkCellZSize);
        
        var _xMax = floor((_struct.xMax - _xShape) / __bonkCellXSize);
        var _yMax = floor((_struct.yMax - _yShape) / __bonkCellYSize);
        var _zMax = floor((_struct.zMax - _zShape) / __bonkCellZSize);
        
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
        
        //TODO - Use matrix transform
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        __BonkSetWorldMatrix(x, y, z);
        
        var _j = 0;
        repeat(array_length(_array) div 3)
        {
            var _x = floor(clamp(_array[_j  ] - _xShape, _minCellX, _maxCellX));
            var _y = floor(clamp(_array[_j+1] - _yShape, _minCellY, _maxCellY));
            var _z = floor(clamp(_array[_j+2] - _zShape, _minCellZ, _maxCellZ));
            
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
        __BonkResetWorldMatrix();
    }
    
    DrawShapes = function(_color = undefined, _wireframe = undefined)
    {
        //TODO - Use matrix transform
        __BonkSetWorldMatrix(x, y, z);
        
        var _bonkTriangleArray = __bonkTriangleArray;
        var _i = 0;
        repeat(array_length(_bonkTriangleArray))
        {
            _bonkTriangleArray[_i].DebugDraw(_color, _wireframe);
            ++_i;
        }
        
        __BonkResetWorldMatrix();
    }
    
    DebugDraw = DrawShapes;
    
    DrawCellsFromArray = function(_array, _color = undefined, _wireframe = true)
    {
        //TODO - Use matrix transform
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
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
            
            UggAABB(_xShape + _cellXSize*(_x + 0.5),
                    _yShape + _cellYSize*(_y + 0.5),
                    _zShape + _cellZSize*(_z + 0.5),
                    _cellXSize, _cellYSize, _cellZSize,
                    _color, _wireframe);
            
            _i += 3;
        }
    }
    
    DrawCellsFromRange = function(_struct, _color = undefined, _wireframe = true, _checkerboard = false)
    {
        //TODO - Use matrix transform
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _cellXSize = __bonkCellXSize;
        var _cellYSize = __bonkCellYSize;
        var _cellZSize = __bonkCellZSize;
        
        var _minCellX = __bonkMinCellX;
        var _minCellY = __bonkMinCellY;
        var _minCellZ = __bonkMinCellZ;
        
        var _maxCellX = __bonkMaxCellX;
        var _maxCellY = __bonkMaxCellY;
        var _maxCellZ = __bonkMaxCellZ;
        
        var _xMin = floor((_struct.xMin - _xShape) / _cellXSize);
        var _yMin = floor((_struct.yMin - _yShape) / _cellYSize);
        var _zMin = floor((_struct.zMin - _zShape) / _cellZSize);
        
        var _xMax = floor((_struct.xMax - _xShape) / _cellXSize);
        var _yMax = floor((_struct.yMax - _yShape) / _cellYSize);
        var _zMax = floor((_struct.zMax - _zShape) / _cellZSize);
        
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
                        UggAABB(_xShape + _cellXSize*(_x + 0.5),
                                _yShape + _cellYSize*(_y + 0.5),
                                _zShape + _cellZSize*(_z + 0.5),
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
        static _staticVectorA = array_create(4, 0);
        var _vectorA = _staticVectorA;
        matrix_transform_vertex(__bonkInverseMatrix, _x1, _y1, _z1, 1, _vectorA);
        
        static _staticVectorB = array_create(4, 0);
        var _vectorB = _staticVectorB;
        matrix_transform_vertex(__bonkInverseMatrix, _x2, _y2, _z2, 1, _vectorB);
        
        return __GetCellsFromLineExtInternal(_vectorA[0], _vectorA[1], _vectorA[2],
                                             _vectorB[0], _vectorB[1], _vectorB[2]);
    }
    
    __GetCellsFromLineExtInternal = function(_x1, _y1, _z1, _x2, _y2, _z2)
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