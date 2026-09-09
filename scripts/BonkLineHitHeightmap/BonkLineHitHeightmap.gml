// Feather disable all

/// @param heightmap
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [groupFilter]
/// @param [struct]

function BonkLineHitHeightmap(_heightmap, _x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
{
    static _staticHitA = new BonkResultHit();
    static _staticHitB = new BonkResultHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    
    with(_heightmap)
    {
        var _cellWidth = cellWidth;
        var _bonkTriangleArray = __bonkTriangleArray;
        
        //TODO - Replace with incremental algo
        var _pointArray = GetCellsFromLineExt(_x1, _y1, _z1, _x2, _y2, _z2);
        var _i = 0;
        repeat(array_length(_pointArray) div 3)
        {
            var _x = _pointArray[_i  ];
            var _y = _pointArray[_i+1];
            //Ignore z
            
            var _index = 2*(_x + _y*_cellWidth);
            repeat(2)
            {
                if ((_bonkTriangleArray[_index++].LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _workingHit)).shape != undefined)
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
                return (_struct == undefined)? _returnHit : _returnHit.__CopyTo(_struct);
            }
            
            _i += 3;
        }
    }
    
    return (_struct == undefined)? _returnHit.__Null() : _struct.__Null();
}