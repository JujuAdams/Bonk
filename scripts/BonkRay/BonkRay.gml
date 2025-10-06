// Feather disable all

/// Constructor that defines a ray - a line with an origin and a direction but (functionally)
/// infinite length. Bonk rays aren't actually infinite in length - their length is determiend
/// by `BONK_RAY_LENGTH`. Bonk rays can be used in the same way as Bonk lines.
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ

function BonkRay(_x, _y, _z, _dX, _dY, _dZ) constructor
{
    static bonkType = BONK_TYPE_RAY;
    static LineHit = __BonkReturnNullHit;
    
    static _hitFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkRayHitAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkRayHitCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRayHitCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkRayHitQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRayHitSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkRayHitTriangle;
        _array[@ BONK_TYPE_WORLD   ] = BonkRayHitWorld;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    dX = _dX;
    dY = _dY;
    dZ = _dZ;
    
    
    
    static SetOrigin = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetDirection = function(_dX = dX, _dY = dY, _dZ = dZ)
    {
        dX = _dX;
        dY = _dY;
        dZ = _dZ;
        
        return self;
    }
    
    static DebugDraw = function(_color = undefined, _thickness = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRayWithArrow(x, y, z, dX, dY, dZ, _color, _thickness, _wireframe);
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x,
            yMin: y,
            zMin: z,
            xMax: x,
            yMax: y,
            zMax: z,
        };
    }
    
    static Hit = function(_otherShape, _groupFilter = -1)
    {
        static _nullHit = new BonkResultHit();
        
        var _hitFunc = _hitFuncLookup[_otherShape.bonkType];
        if (is_callable(_hitFunc))
        {
            return _hitFunc(_otherShape, x, y, z, dX, dY, dZ, _groupFilter);
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
    
    static CollisionLineList = function(_objectOrArray = BonkObject, _groupFilter = -1, _list = undefined)
    {
        return BonkCollisionLineList(x, y, x + BONK_RAY_LENGTH*dX, y + BONK_RAY_LENGTH*dY, _objectOrArray, _groupFilter, _list);
    }
    
    static HitFirstExt = function(_targetShapes, _groupFilter = -1)
    {
        return BonkRayHitFirstExt(x, y, z, dX, dY, dZ, _targetShapes, _groupFilter);
    }
    
    static HitFirst = function(_objectOrArray = BonkObject, _groupFilter = -1)
    {
        return BonkRayHitFirst(x, y, z, dX, dY, dZ, _objectOrArray, _groupFilter);
    }
}