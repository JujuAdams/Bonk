/// @param cellSizeX
/// @param cellSizeY
/// @param cellSizeZ

function BonkMeshData(_cellSizeX, _cellSizeY, _cellSizeZ) constructor
{
    __bonkCellXSize = _cellSizeX;
    __bonkCellYSize = _cellSizeY;
    __bonkCellZSize = _cellSizeZ;
    
    __bonkWidth  = 1;
    __bonkHeight = 1;
    
    __bonkMinCellX = 0;
    __bonkMinCellY = 0;
    __bonkMinCellZ = 0;
    
    __bonkMaxCellX = 0;
    __bonkMaxCellY = 0;
    __bonkMaxCellZ = 0;
    
    __bonkSpatialMap = ds_map_create();
    __bonkTriangleArray = [];
    
    __bonkWorkerArray = [];
    
    static AddVertexBuffer = function(_vertexBufferArray, _vertexFormat, _matrix = matrix_build_identity(), _applySoftEdges = true)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassMeshWorker(self, _vertexBufferArray, _vertexFormat, _matrix, _applySoftEdges);
        _worker.Force();
        
        return self;
    }
    
    static AddVertexBufferAsync = function(_vertexBufferArray, _vertexFormat, _budget = 12, _matrix = matrix_build_identity(), _applySoftEdges = true)
    {
        if (not is_array(_vertexBufferArray))
        {
            _vertexBufferArray = [_vertexBufferArray];
        }
        
        var _worker = new __BonkClassMeshWorker(self, _vertexBufferArray, _vertexFormat, _matrix, _applySoftEdges);
        _worker.__StartAsync();
        
        return _worker;
    }
    
    static GetVertexBufferAsyncRemaining = function()
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
    
    static GetVertexBufferAsyncCount = function()
    {
        return array_length(__bonkWorkerArray);
    }
    
    static CancelVertexBufferAsync = function()
    {
        var _i = array_length(__bonkWorkerArray)-1;
        repeat(array_length(__bonkWorkerArray))
        {
            __bonkWorkerArray[_i].Cancel();
            --_i;
        }
        
        return self;
    }
    
    static __EnsureShapeArrayFromCell = function(_x, _y, _z)
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
}