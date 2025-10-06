// Feather disable all

/// @param x
/// @param y
/// @param z

function BonkPoint(_x, _y, _z) constructor
{
    static bonkType = BONK_TYPE_POINT;
    static LineHit = __BonkReturnNullHit;
    
    static __bonkTouchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkPointTouchAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkPointTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkPointTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkPointTouchSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggPoint(x, y, z, _color, _wireframe);
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
    
    static Touch = function(_otherShape)
    {
        var _insideFunc = __bonkTouchFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(_otherShape, x, y, z);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkError($".Touch() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
}