// Feather disable all

/// @param heightmap
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitHeightmap(_heightmap, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined)
{
    static _staticHitA = new BonkResultHit();
    static _staticHitB = new BonkResultHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    
    with(_heightmap)
    {
        //Correct for the heightmap's position
        _x1 -= x;
        _y1 -= y;
        _z1 -= z;
        
        _x2 -= x;
        _y2 -= y;
        _z2 -= z;
        
        var _cellCountX = cellCountX;
        var _bonkTriangleArray = __bonkTriangleArray;
        var _maxTriangles = array_length(_bonkTriangleArray);
        
        //TODO - Replace with incremental algo
        var _pointArray = __GetCellsFromLineExtInternal(_x1, _y1, _z1, _x2, _y2, _z2);
        var _i = 0;
        repeat(array_length(_pointArray) div 2)
        {
            var _x = _pointArray[_i  ];
            var _y = _pointArray[_i+1];
            
            var _index = 2*(_x + _y*_cellCountX);
            if (_index >= _maxTriangles) break; //FIXME - This shouldn't be necessary
            
            repeat(2)
            {
                if ((_bonkTriangleArray[_index++].LineHit(_x1, _y1, _z1, _x2, _y2, _z2, -1, _workingHit)).shape != undefined)
                {
                    var _distance = point_distance_3d(_x1, _y1, _z1, _workingHit.x, _workingHit.y, _workingHit.z);
                    if (_distance < _closestDistance)
                    {
                        _closestDistance = _distance;
                        
                        //Swap over
                        var _tempHit = _workingHit;
                        _workingHit = _returnHit;
                        _returnHit  = _tempHit;
                    }
                }
            }
            
            if (not is_infinity(_closestDistance))
            {
                //Re-correct for the heightmap's position
                _returnHit.x += x;
                _returnHit.y += y;
                _returnHit.z += z;
                
                return (_struct == undefined)? _returnHit : _returnHit.__CopyTo(_struct);
            }
            
            _i += 2;
        }
    }
    
    return (_struct == undefined)? _returnHit.Null() : _struct.Null();
}