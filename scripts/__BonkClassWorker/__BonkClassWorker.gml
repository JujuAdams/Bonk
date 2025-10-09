// Feather disable all

/// @param world
/// @param vertexbufferArray
/// @param vertexFormat
/// @param matrix

function __BonkClassWorker(_world, _vertexBufferArray, _vertexFormat, _matrix) constructor
{
    __world             = _world;
    __vertexBufferArray = _vertexBufferArray;
    __vertexFormat      = _vertexFormat;
    __matrix            = _matrix;
    
    __finished   = false;
    __timeSource = undefined;
    __budget     = undefined;
    
    
    static GetFinished = function()
    {
        return __finished;
    }
    
    static Force = function()
    {
        while(not __finished)
        {
            __Update();
        }
        
        if (__timeSource != undefined)
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
        }
        
        __timeSource = undefined;
    }
    
    static Cancel = function()
    {
        __finished = true;
        
        if (__timeSource != undefined)
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            __timeSource = undefined;
        }
    }
    
    static __StartAsync = function(_budget)
    {
        __budget = _budget;
        
        __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            var _startTime = current_time;
            while((current_time - _startTime < _budget) && (not __finished))
            {
                __Update();
            }
            
            if (__finished)
            {
                if (__timeSource != undefined)
                {
                    time_source_stop(__timeSource);
                    time_source_destroy(__timeSource);
                }
                
                __timeSource = undefined;
            }
        },
        -1, []);
        
        time_source_start(__timeSource);
        
        return self;
    }
    
    __Update = function()
    {
        if (__finished) return;
        
        var _world             = __world;
        var _vertexBufferArray = __vertexBufferArray;
        var _vertexFormat      = __vertexFormat;
        var _matrix            = __matrix;
        
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
                
                _world.__Add(_bonkTri); //Use the internal version to avoid expensive instance checks
            }
            
            buffer_delete(_buffer);
            
            ++_i;
        }
        
        __finished = true;
    }
}