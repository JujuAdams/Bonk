// Feather disable all

/// @param mesh
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]
/// @param [groupFilter]

function BonkLineHitMesh(_mesh, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined, _groupFilter = -1)
{
    static _map = ds_map_create();
    
    static _staticHitA = new BonkResultHit();
    static _staticHitB = new BonkResultHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    var _closestGridX = infinity;
    var _closestGridY = infinity;
    var _closestGridZ = infinity;
    
    with(_mesh)
    {
        var _cellXSize = __bonkCellXSize;
        var _cellYSize = __bonkCellYSize;
        var _cellZSize = __bonkCellZSize;
        
        //TODO - Replace with incremental algo
        var _pointArray = GetCellsFromLineExt(_x1, _y1, _z1, _x2, _y2, _z2);
        var _i = 0;
        repeat(array_length(_pointArray) div 3)
        {
            var _x = _pointArray[_i  ];
            var _y = _pointArray[_i+1];
            var _z = _pointArray[_i+2];
            
            var _triDefArray = _mesh.GetTriDefArrayFromCell(_x, _y, _z); //TODO - Optimize by inlining
            var _j = 0;
            repeat(array_length(_triDefArray))
            {
                var _triDef = _triDefArray[_j];
                if (not ds_map_exists(_map, _triDef))
                {
                    _map[? _triDef] = true;
                    
                    if (__BonkLineHitTriangle(self,
                                              _x1, _y1, _z1,
                                              _x2, _y2, _z2,
                                              _triDef[__BONK_MESH_TRI_X1], _triDef[__BONK_MESH_TRI_Y1], _triDef[__BONK_MESH_TRI_Z1],
                                              _triDef[__BONK_MESH_TRI_X2], _triDef[__BONK_MESH_TRI_Y2], _triDef[__BONK_MESH_TRI_Z2],
                                              _triDef[__BONK_MESH_TRI_X3], _triDef[__BONK_MESH_TRI_Y3], _triDef[__BONK_MESH_TRI_Z3],
                                              _workingHit).shape != undefined)
                    {
                        var _distance = point_distance_3d(_x1, _y1, _z1, _workingHit.x, _workingHit.y, _workingHit.z);
                        if (_distance < _closestDistance)
                        {
                            _closestDistance = _distance;
                            _closestGridX = floor(_workingHit.x / _cellXSize);
                            _closestGridY = floor(_workingHit.y / _cellYSize);
                            _closestGridZ = floor(_workingHit.z / _cellZSize);
                            
                            //Swap over
                            var _tempHit = _workingHit;
                            _workingHit = _returnHit;
                            _returnHit  = _tempHit;
                        }
                    }
                }
                
                ++_j;
            }
            
            //Cells returned by `GetCellsFromLineExt()` are ordered from the origin of the line towards
            //the end of the line. If we have a hit already then we don't need to check beyond the cell
            //that contains the hit
            if ((_closestGridX == _x) && (_closestGridY == _y) && (_closestGridZ == _z))
            {
                ds_map_clear(_map);
                return (_struct == undefined)? _returnHit : _returnHit.__CopyTo(_struct);
            }
            
            _i += 3;
        }
    }
    
    ds_map_clear(_map);
    return (_struct == undefined)? _returnHit.Null() : _struct.Null();
}