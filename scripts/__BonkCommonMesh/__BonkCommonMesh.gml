// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize


//Order must match `__BonkCapsuleCollideTriangle()`

#macro __BONK_MESH_TRI_X1  0
#macro __BONK_MESH_TRI_Y1  1
#macro __BONK_MESH_TRI_Z1  2

#macro __BONK_MESH_TRI_X2  3
#macro __BONK_MESH_TRI_Y2  4
#macro __BONK_MESH_TRI_Z2  5

#macro __BONK_MESH_TRI_X3  6
#macro __BONK_MESH_TRI_Y3  7
#macro __BONK_MESH_TRI_Z3  8

#macro __BONK_MESH_TRI_DX12   9
#macro __BONK_MESH_TRI_DY12  10
#macro __BONK_MESH_TRI_DZ12  11

#macro __BONK_MESH_TRI_DX23  12
#macro __BONK_MESH_TRI_DY23  13
#macro __BONK_MESH_TRI_DZ23  14

#macro __BONK_MESH_TRI_DX31  15
#macro __BONK_MESH_TRI_DY31  16
#macro __BONK_MESH_TRI_DZ31  17

#macro __BONK_MESH_TRI_NORMAL_X  18
#macro __BONK_MESH_TRI_NORMAL_Y  19
#macro __BONK_MESH_TRI_NORMAL_Z  20

#macro __BONK_MESH_TRI_HARD_EDGE_12  21
#macro __BONK_MESH_TRI_HARD_EDGE_23  22
#macro __BONK_MESH_TRI_HARD_EDGE_31  23

#macro __BONK_MESH_TRI_LENGTH_SQR_12  24
#macro __BONK_MESH_TRI_LENGTH_SQR_23  25
#macro __BONK_MESH_TRI_LENGTH_SQR_31  26

#macro __BONK_MESH_TRI_SIZE  27



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
    __bonkTriDefArray = [];
    
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
        
        var _triDefArray = __bonkTriDefArray;
        var _i = 0;
        repeat(array_length(_triDefArray))
        {
            var _triDef = _triDefArray[_i];
            
            matrix_transform_vertex(_transformMatrix,
                                    _triDef[__BONK_MESH_TRI_X1], _triDef[__BONK_MESH_TRI_Y1], _triDef[__BONK_MESH_TRI_Z1], 1,
                                    _vector);
            var _x1 = _triDef[__BONK_MESH_TRI_X1]; var _y1 = _triDef[__BONK_MESH_TRI_Y1]; var _z1 = _triDef[__BONK_MESH_TRI_Z1];
            array_copy(_triDef, __BONK_MESH_TRI_X1, _vector, 0, 3);
            
            matrix_transform_vertex(_transformMatrix,
                                    _triDef[__BONK_MESH_TRI_X2], _triDef[__BONK_MESH_TRI_Y2], _triDef[__BONK_MESH_TRI_Z2], 1,
                                    _vector);
            var _x2 = _triDef[__BONK_MESH_TRI_X2]; var _y2 = _triDef[__BONK_MESH_TRI_Y2]; var _z2 = _triDef[__BONK_MESH_TRI_Z2];
            array_copy(_triDef, __BONK_MESH_TRI_X2, _vector, 0, 3);
            
            matrix_transform_vertex(_transformMatrix,
                                    _triDef[__BONK_MESH_TRI_X3], _triDef[__BONK_MESH_TRI_Y3], _triDef[__BONK_MESH_TRI_Z3], 1,
                                    _vector);
            var _x3 = _triDef[__BONK_MESH_TRI_X3]; var _y3 = _triDef[__BONK_MESH_TRI_Y3]; var _z3 = _triDef[__BONK_MESH_TRI_Z3];
            array_copy(_triDef, __BONK_MESH_TRI_X3, _vector, 0, 3);
            
            _triDef[@ __BONK_MESH_TRI_DX12] = _x2 - _x1; _triDef[@ __BONK_MESH_TRI_DY12] = _y2 - _y1; _triDef[@ __BONK_MESH_TRI_DZ12] = _z2 - _z1;
            _triDef[@ __BONK_MESH_TRI_DX23] = _x3 - _x2; _triDef[@ __BONK_MESH_TRI_DY23] = _y3 - _y2; _triDef[@ __BONK_MESH_TRI_DZ23] = _z3 - _z2;
            _triDef[@ __BONK_MESH_TRI_DX31] = _x1 - _x3; _triDef[@ __BONK_MESH_TRI_DY31] = _y1 - _y3; _triDef[@ __BONK_MESH_TRI_DZ31] = _z1 - _z3;
            
            matrix_transform_vertex(_transformMatrix,
                                    _triDef[__BONK_MESH_TRI_NORMAL_X], _triDef[__BONK_MESH_TRI_NORMAL_Y], _triDef[__BONK_MESH_TRI_NORMAL_Z], 0,
                                    _vector);
            array_copy(_triDef, __BONK_MESH_TRI_NORMAL_X, _vector, 0, 3);
            
            var _xMin = min(_x1, _x2, _x3);
            var _yMin = min(_y1, _y2, _y3);
            var _zMin = min(_z1, _z2, _z3);
            
            var _xMax = max(_x1, _x2, _x3);
            var _yMax = max(_y1, _y2, _y3);
            var _zMax = max(_z1, _z2, _z3);
            
            var _cellXMin = clamp(floor(_xMin / _bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellYMin = clamp(floor(_yMin / _bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZMin = clamp(floor(_zMin / _bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
            var _cellXMax = clamp(floor(_xMax / _bonkCellXSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellYMax = clamp(floor(_yMax / _bonkCellYSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            var _cellZMax = clamp(floor(_zMax / _bonkCellZSize), BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX);
            
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
                        array_push(_mesh.__EnsureShapeArrayFromCell(_x, _y, _z), _triDef);
                        ++_x;
                    }
                    
                    ++_y;
                }
                
                ++_z;
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
        //TODO
        return false;
        
        
        
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
            var _triDefArray = GetTriDefArrayFromCell(_shapeXMin, _shapeYMin, _shapeZMin);
            var _i = 0;
            repeat(array_length(_triDefArray))
            {
                if (_triDefArray[_i].Touch(_subjectShape, _groupFilter, true))
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
                        var _triDefArray = __GetTriDefArrayFromCellUnsafe(_x, _y, _z);
                        
                        var _i = 0;
                        repeat(array_length(_triDefArray))
                        {
                            var _shape = _triDefArray[_i];
                            if (not ds_map_exists(_map, _shape))
                            {
                                _map[? _shape] = true;
                                
                                if (_triDefArray[_i].Touch(_subjectShape, _groupFilter))
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
        //TODO - Add group filtering
        
        static _map = ds_map_create();
        
        static _executeArrayStatic = [];
        var _executeArray = _executeArrayStatic;
        
        static _staticCollision = new BonkResultCollide();
        static _staticDeflect = new BonkResultDeflect();
        var _result = _staticDeflect;
        
        var _largestGrippyDepth   = -infinity;
        var _largestSlipperyDepth = -infinity;
        
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
        }
        else
        {
            with(_subjectShape)
            {
                if (bonkType == BONK_TYPE_CAPSULE)
                {
                    var _executeArrayOffset = 6;
                    
                    var _executeArray = array_resize(_executeArray, __BONK_MESH_TRI_SIZE + _executeArrayOffset + 1);
                    _executeArray[@ 0] = x;
                    _executeArray[@ 1] = y;
                    _executeArray[@ 2] = z - 0.5*height + radius;
                    _executeArray[@ 3] = height - 2*radius;
                    _executeArray[@ 4] = radius;
                    _executeArray[@ 5] = self;
                    _executeArray[@ 6 + __BONK_MESH_TRI_SIZE] = _staticCollision;
                    
                    var _script = __BonkCapsuleCollideTriangle;
                }
                else if (bonkType == BONK_TYPE_SPHERE)
                {
                    var _executeArrayOffset = 5;
                    
                    var _executeArray = array_resize(_executeArray, __BONK_MESH_TRI_SIZE + _executeArrayOffset + 1);
                    _executeArray[@ 0] = x;
                    _executeArray[@ 1] = y;
                    _executeArray[@ 2] = z;
                    _executeArray[@ 3] = radius;
                    _executeArray[@ 5] = self;
                    _executeArray[@ 6 + __BONK_MESH_TRI_SIZE] = _staticCollision;
                    
                    var _script = __BonkSphereCollideTriangle;
                }
                else //No valid collision
                {
                    return _result.Null();
                }
                
                _shapeXMin = clamp(_shapeXMin, _minCellX, _maxCellX);
                _shapeYMin = clamp(_shapeYMin, _minCellY, _maxCellY);
                _shapeZMin = clamp(_shapeZMin, _minCellZ, _maxCellZ);
                
                _shapeXMax = clamp(_shapeXMax, _minCellX, _maxCellX);
                _shapeYMax = clamp(_shapeYMax, _minCellY, _maxCellY);
                _shapeZMax = clamp(_shapeZMax, _minCellZ, _maxCellZ);
                
                if ((_shapeXMin == _shapeXMax) && (_shapeYMin == _shapeYMax) && (_shapeZMin == _shapeZMax))
                {
                    var _triDefArray = other.GetTriDefArrayFromCell(_shapeXMin, _shapeYMin, _shapeZMin);
                    var _i = 0;
                    repeat(array_length(_triDefArray))
                    {
                        var _triDef = _triDefArray[_i];
                        if (not ds_map_exists(_map, _triDef))
                        {
                            _map[? _triDef] = true;
                            array_copy(_executeArray, _executeArrayOffset, _triDef, 0, __BONK_MESH_TRI_SIZE);
                            
                            var _collisionData = script_execute_ext(_script, _executeArray);
                            if (_collisionData.shape != undefined)
                            {
                                with(_subjectShape)
                                {
                                    var _dX = _collisionData.dX;
                                    var _dY = _collisionData.dY;
                                    var _dZ = _collisionData.dZ;
                                    
                                    var _distance = max(0.00001, sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ));
                                    if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                                    {
                                        //If the slope is shallow enough, just move upwards
                                        //This movement is approximate but good enough
                                        AddPosition(0, 0, _distance);
                                        
                                        if (_distance > _largestGrippyDepth)
                                        {
                                            _largestGrippyDepth = _distance;
                                            _collisionData.__CopyTo(_result.grippyCollision);
                                        }
                                    }
                                    else
                                    {
                                        //Otherwise move out as usual which will typically slide the subject down slopes
                                        AddPosition(_dX, _dY, _dZ);
                                        
                                        if (_distance > _largestSlipperyDepth)
                                        {
                                            _largestSlipperyDepth = _distance;
                                            _collisionData.__CopyTo(_result.slipperyCollision);
                                        }
                                    }
                                }
                            }
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
                                var _triDefArray = other.GetTriDefArrayFromCell(_x, _y, _z);
                                var _i = 0;
                                repeat(array_length(_triDefArray))
                                {
                                    var _triDef = _triDefArray[_i];
                                    if (not ds_map_exists(_map, _triDef))
                                    {
                                        _map[? _triDef] = true;
                                        array_copy(_executeArray, _executeArrayOffset, _triDef, 0, __BONK_MESH_TRI_SIZE);
                                        
                                        var _collisionData = script_execute_ext(_script, _executeArray);
                                        if (_collisionData.shape != undefined)
                                        {
                                            with(_subjectShape)
                                            {
                                                var _dX = _collisionData.dX;
                                                var _dY = _collisionData.dY;
                                                var _dZ = _collisionData.dZ;
                                                
                                                var _distance = max(0.00001, sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ));
                                                if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                                                {
                                                    //If the slope is shallow enough, just move upwards
                                                    //This movement is approximate but good enough
                                                    AddPosition(0, 0, _distance);
                                                    
                                                    if (_distance > _largestGrippyDepth)
                                                    {
                                                        _largestGrippyDepth = _distance;
                                                        _collisionData.__CopyTo(_result.grippyCollision);
                                                    }
                                                }
                                                else
                                                {
                                                    //Otherwise move out as usual which will typically slide the subject down slopes
                                                    AddPosition(_dX, _dY, _dZ);
                                                    
                                                    if (_distance > _largestSlipperyDepth)
                                                    {
                                                        _largestSlipperyDepth = _distance;
                                                        _collisionData.__CopyTo(_result.slipperyCollision);
                                                    }
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
            }
        }
        
        with(_result)
        {
            if (not is_infinity(_largestGrippyDepth))
            {
                primaryCollision = grippyCollision;
                deflectType = BONK_DEFLECT_GRIPPY;
                
                if (is_infinity(_largestSlipperyDepth))
                {
                    slipperyCollision.Null();
                }
            }
            else
            {
                grippyCollision.Null();
                primaryCollision = slipperyCollision;
                
                if (not is_infinity(_largestSlipperyDepth))
                {
                    deflectType = BONK_DEFLECT_SLIPPERY;
                }
                else
                {
                    slipperyCollision.Null();
                    deflectType = BONK_DEFLECT_NONE;
                }
            }
            
            return self;
        }
    }
    
    Collide = function(_subjectShape, _groupFilter = -1, _struct = undefined)
    {
        //TODO - Add group filtering
        
        static _map = ds_map_create();
        static _nullCollisionData = new BonkResultCollide();
        static _executeArrayStatic = [];
        
        var _executeArray = _executeArrayStatic;
        
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
            with(_subjectShape) //TODO - Not always a capsule!
            {
                if (bonkType == BONK_TYPE_CAPSULE)
                {
                    var _executeArrayOffset = 6;
                    
                    var _executeArray = array_resize(_executeArray, __BONK_MESH_TRI_SIZE + _executeArrayOffset + 1);
                    _executeArray[@ 0] = x;
                    _executeArray[@ 1] = y;
                    _executeArray[@ 2] = z - 0.5*height + radius;
                    _executeArray[@ 3] = height - 2*radius;
                    _executeArray[@ 4] = radius;
                    _executeArray[@ 5] = self;
                    _executeArray[@ 6 + __BONK_MESH_TRI_SIZE] = _struct;
                    
                    var _script = __BonkCapsuleCollideTriangle;
                }
                else if (bonkType == BONK_TYPE_SPHERE)
                {
                    var _executeArrayOffset = 5;
                    
                    var _executeArray = array_resize(_executeArray, __BONK_MESH_TRI_SIZE + _executeArrayOffset + 1);
                    _executeArray[@ 0] = x;
                    _executeArray[@ 1] = y;
                    _executeArray[@ 2] = z;
                    _executeArray[@ 3] = radius;
                    _executeArray[@ 5] = self;
                    _executeArray[@ 6 + __BONK_MESH_TRI_SIZE] = _struct;
                    
                    var _script = __BonkSphereCollideTriangle;
                }
                else //No valid collision
                {
                    return _struct.Null();
                }
                
                _shapeXMin = clamp(_shapeXMin, _minCellX, _maxCellX);
                _shapeYMin = clamp(_shapeYMin, _minCellY, _maxCellY);
                _shapeZMin = clamp(_shapeZMin, _minCellZ, _maxCellZ);
                
                _shapeXMax = clamp(_shapeXMax, _minCellX, _maxCellX);
                _shapeYMax = clamp(_shapeYMax, _minCellY, _maxCellY);
                _shapeZMax = clamp(_shapeZMax, _minCellZ, _maxCellZ);
                
                if ((_shapeXMin == _shapeXMax) && (_shapeYMin == _shapeYMax) && (_shapeZMin == _shapeZMax))
                {
                    var _triDefArray = other.GetTriDefArrayFromPoint(_subjectShape.x, _subjectShape.y, _subjectShape.z);
                    var _i = 0;
                    repeat(array_length(_triDefArray))
                    {
                        var _triDef = _triDefArray[_i];
                        array_copy(_executeArray, _executeArrayOffset, _triDef, 0, __BONK_MESH_TRI_SIZE);
                        
                        var _reaction = script_execute_ext(_script, _executeArray);
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
                                var _triDefArray = other.__GetTriDefArrayFromCellUnsafe(_x, _y, _z);
                                
                                var _i = 0;
                                repeat(array_length(_triDefArray))
                                {
                                    var _triDef = _triDefArray[_i];
                                    if (not ds_map_exists(_map, _triDef))
                                    {
                                        _map[? _triDef] = true;
                                        array_copy(_executeArray, _executeArrayOffset, _triDef, 0, __BONK_MESH_TRI_SIZE);
                                        
                                        var _reaction = script_execute_ext(_script, _executeArray);
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
    
    GetTriDefArrayFromPoint = function(_x, _y, _z)
    {
        return GetTriDefArrayFromCell(_x / __bonkCellXSize, _y / __bonkCellYSize, _z / __bonkCellZSize);
    }
    
    GetTriDefArrayFromCell = function(_x, _y, _z)
    {
        static _emptyArray = [];
        
        _x = floor(clamp(_x, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _y = floor(clamp(_y, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        _z = floor(clamp(_z, BONK_WORLD_CELL_MIN, BONK_WORLD_CELL_MAX));
        
        return struct_get_from_hash(__bonkSpatialDict, (_x + BONK_WORLD_CELL_MIN) + ((_y + BONK_WORLD_CELL_MIN) << 11) + ((_z + BONK_WORLD_CELL_MIN) << 22)) ?? _emptyArray;
    }
    
    __GetTriDefArrayFromCellUnsafe = function(_x, _y, _z)
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
    
    __DrawTriDef = function(_triDef, _color = undefined, _wireframe = undefined, _softEdgeColor = undefined)
    {
        __BONK_VERIFY_UGG
        
        if (_wireframe)
        {
            if (_softEdgeColor == undefined)
            {
                _softEdgeColor = merge_colour(_color, c_white, 0.66);
            }
            
            if (_color == _softEdgeColor)
            {
                UggTriangle(_triDef[__BONK_MESH_TRI_X1], _triDef[__BONK_MESH_TRI_Y1], _triDef[__BONK_MESH_TRI_Z1],
                            _triDef[__BONK_MESH_TRI_X2], _triDef[__BONK_MESH_TRI_Y2], _triDef[__BONK_MESH_TRI_Z2],
                            _triDef[__BONK_MESH_TRI_X3], _triDef[__BONK_MESH_TRI_Y3], _triDef[__BONK_MESH_TRI_Z3],
                            _color, true);
            }
            else
            {
                UggLine(_triDef[__BONK_MESH_TRI_X1], _triDef[__BONK_MESH_TRI_Y1], _triDef[__BONK_MESH_TRI_Z1],
                        _triDef[__BONK_MESH_TRI_X2], _triDef[__BONK_MESH_TRI_Y2], _triDef[__BONK_MESH_TRI_Z2],
                        _triDef[__BONK_MESH_TRI_HARD_EDGE_12]? _color : _softEdgeColor, undefined, true);
                
                UggLine(_triDef[__BONK_MESH_TRI_X2], _triDef[__BONK_MESH_TRI_Y2], _triDef[__BONK_MESH_TRI_Z2],
                        _triDef[__BONK_MESH_TRI_X3], _triDef[__BONK_MESH_TRI_Y3], _triDef[__BONK_MESH_TRI_Z3],
                        _triDef[__BONK_MESH_TRI_HARD_EDGE_23]? _color : _softEdgeColor, undefined, true);
                
                UggLine(_triDef[__BONK_MESH_TRI_X3], _triDef[__BONK_MESH_TRI_Y3], _triDef[__BONK_MESH_TRI_Z3],
                        _triDef[__BONK_MESH_TRI_X1], _triDef[__BONK_MESH_TRI_Y1], _triDef[__BONK_MESH_TRI_Z1],
                        _triDef[__BONK_MESH_TRI_HARD_EDGE_31]? _color : _softEdgeColor, undefined, true);
            }
        }
        else
        {
            UggTriangle(_triDef[__BONK_MESH_TRI_X1], _triDef[__BONK_MESH_TRI_Y1], _triDef[__BONK_MESH_TRI_Z1],
                        _triDef[__BONK_MESH_TRI_X2], _triDef[__BONK_MESH_TRI_Y2], _triDef[__BONK_MESH_TRI_Z2],
                        _triDef[__BONK_MESH_TRI_X3], _triDef[__BONK_MESH_TRI_Y3], _triDef[__BONK_MESH_TRI_Z3],
                        _color, false);
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
                    var _triDefArray = __GetTriDefArrayFromCellUnsafe(_x, _y, _z);
                    var _i = 0;
                    repeat(array_length(_triDefArray))
                    {
                        var _triDef = _triDefArray[_i];
                        if (not ds_map_exists(_map, _triDef))
                        {
                            _map[? _triDef] = true;
                            __DrawTriDef(_triDef, _color, _wireframe);
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
            
            var _triDefArray = __GetTriDefArrayFromCellUnsafe(_x, _y, _z);
            var _i = 0;
            repeat(array_length(_triDefArray))
            {
                var _triDef = _triDefArray[_i];
                if (not ds_map_exists(_map, _triDef))
                {
                    _map[? _triDef] = true;
                    __DrawTriDef(_triDef, _color, _wireframe);
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