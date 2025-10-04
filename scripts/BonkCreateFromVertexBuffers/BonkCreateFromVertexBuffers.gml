// Feather disable all

/// @param vertexBufferArray
/// @param vertexFormat
/// @param [matrix]
/// @param [object=BonkObject]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateFromVertexBuffers(_vertexBufferArray, _vertexFormat, _matrix = undefined, _object = BonkObject)
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
                    
                    BonkCreateTriangle(_a[0], _a[1], _a[2],
                                       _b[0], _b[1], _b[2],
                                       _c[0], _c[1], _c[2],
                                       _object, _groupVector);
                }
                else
                {
                    BonkCreateTriangle(_x1, _y1, _z1,
                                       _x2, _y2, _z2,
                                       _x3, _y3, _z3,
                                       _object, _groupVector);
                }
            }
            
            buffer_delete(_buffer);
            
            ++_i;
        }
}