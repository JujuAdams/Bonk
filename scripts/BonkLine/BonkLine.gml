// Feather disable all

/// Constructor that defines a line segment that can be used for various Bonk functions.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLine(_x1, _y1, _z1, _x2, _y2, _z2) constructor
{
    static bonkType = BONK_TYPE_LINE;
    static LineHit = __BonkReturnNullHit;
    
    static _hitFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkLineHitAAB;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkLineHitCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkLineHitCylinder;
        _array[@ BONK_TYPE_QUAD     ] = BonkLineHitQuad;
        _array[@ BONK_TYPE_SPHERE   ] = BonkLineHitSphere;
        _array[@ BONK_TYPE_TRIANGLE ] = BonkLineHitTriangle;
        _array[@ BONK_TYPE_WORLD    ] = BonkLineHitWorld;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkLineHitHeightmap;
        return _array;
    })();
    
    
    
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        return self;
    }
    
    static SetFromPOV = function(_normalizedMouseX, _normalizedMouseY, _viewMatrix, _projMatrix)
    {
        static _matrixStatic = array_create(16, 0);
        static _vectorStatic = array_create(4, 0);
        
        var _matrix = _matrixStatic;
        var _vector = _vectorStatic
        
        matrix_multiply(_viewMatrix, _projMatrix, _matrix);
        matrix_inverse(_matrix, _matrix);
        
        matrix_transform_vertex(_matrix, _normalizedMouseX, -_normalizedMouseY, 0, 1, _vector);
        var _w = _vector[3];
        x1 = _vector[0] / _w;
        y1 = _vector[1] / _w;
        z1 = _vector[2] / _w;
        
        matrix_transform_vertex(_matrix, _normalizedMouseX, -_normalizedMouseY, 1, 1, _vector);
        var _w = _vector[3];
        x2 = _vector[0] / _w;
        y2 = _vector[1] / _w;
        z2 = _vector[2] / _w;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: min(x1, x2),
            yMin: min(y1, y2),
            zMin: min(z1, z2),
            xMax: max(x1, x2),
            yMax: max(y1, y2),
            zMax: max(z1, z2),
        };
    }
    
    static DebugDraw = function(_color = undefined, _thickness = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggArrow(x1, y1, z1, x2, y2, z2, undefined, _color, _thickness, _wireframe);
    }
    
    static Hit = function(_otherShape, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        var _hitFunc = _hitFuncLookup[_otherShape.bonkType];
        if (is_callable(_hitFunc))
        {
            return _hitFunc(_otherShape, x1, y1, z1, x2, y2, z2, _struct, _groupFilter);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkError($".Hit() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return _nullHit;
    }
    
    static HitFirstExt = function(_targetShapes, _groupFilter = -1, _struct = undefined)
    {
        return BonkLineHitFirstExt(x1, y1, z1, x2, y2, z2, _targetShapes, _groupFilter, _struct);
    }
    
    static HitFirst = function(_objectOrArray = BonkObject, _groupFilter = -1, _struct = undefined)
    {
        return BonkLineHitFirst(x1, y1, z1, x2, y2, z2, _objectOrArray, _groupFilter, _struct);
    }
    
    static CollisionLineList = function(_objectOrArray = BonkObject, _groupFilter = -1, _list = undefined)
    {
        return BonkCollisionLineList(x1, y1, x2, y2, _objectOrArray, _groupFilter, _list);
    }
}