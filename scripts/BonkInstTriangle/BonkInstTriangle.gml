// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3
/// @param [objectXY]
/// @param [objectYZ]

function BonkInstTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(0, 0, 0, _objectXY))
    {
        bonkType = BONK_TYPE_TRIANGLE;
        lineHitFunction = BonkLineHitTriangle;
        
        static _collideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_CAPSULE] = BonkTriangleCollideCapsule;
            _array[@ BONK_TYPE_SPHERE ] = BonkTriangleCollideSphere;
            return _array;
        })();
        
        static _insideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_CAPSULE] = BonkTriangleInsideCapsule;
            _array[@ BONK_TYPE_SPHERE ] = BonkTriangleInsideSphere;
            return _array;
        })();
        
        __collideFuncLookup = _collideFuncLookup;
        __insideFuncLookup  = _insideFuncLookup;
        
        
        
        x1 = _x1;
        y1 = _y1;
        z1 = _z1;
        
        x2 = _x2;
        y2 = _y2;
        z2 = _z2;
        
        x3 = _x3;
        y3 = _y3;
        z3 = _z3;
        
        
        
        sprite_index = BonkMaskAAB;
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(0, 0, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                sprite_index = BonkMaskAAB;
            }
        }
        
        
        
        Refresh = function()
        {
            dX12 = x2 - x1;
            dY12 = y2 - y1;
            dZ12 = z2 - z1;
            
            dX23 = x3 - x2;
            dY23 = y3 - y2;
            dZ23 = z3 - z2;
            
            dX31 = x1 - x3;
            dY31 = y1 - y3;
            dZ31 = z1 - z3;
            
            lengthSqr12 = dX12*dX12 + dY12*dY12 + dZ12*dZ12;
            lengthSqr23 = dX23*dX23 + dY23*dY23 + dZ23*dZ23;
            lengthSqr31 = dX31*dX31 + dY31*dY31 + dZ31*dZ31;
            
            normalX = dZ12*dY31 - dY12*dZ31;
            normalY = dX12*dZ31 - dZ12*dX31;
            normalZ = dY12*dX31 - dX12*dY31;
            
            var _length = sqrt(normalX*normalX + normalY*normalY + normalZ*normalZ);
            if (_length > 0)
            {
                var _coeff = 1 / _length;
                normalX *= _coeff;
                normalY *= _coeff;
                normalZ *= _coeff;
            }
            
            var _minX = min(x1, x2, x3);
            var _maxX = max(x1, x2, x3);
            var _minY = min(y1, y2, y3);
            var _maxY = max(y1, y2, y3);
            var _minZ = min(z1, z2, z3);
            var _maxZ = max(z1, z2, z3);
            
            x = 0.5*(_minX + _maxX);
            y = 0.5*(_minY + _maxY);
            z = 0.5*(_minZ + _maxZ);
            
            image_xscale = (_maxX - _minX) / BONK_MASK_SIZE;
            image_yscale = (_maxY - _minY) / BONK_MASK_SIZE;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.x = x;
                __instanceXZ.y = z;
                __instanceXZ.image_xscale = image_xscale;
                __instanceXZ.image_yscale = (_maxZ - _minZ) / BONK_MASK_SIZE;
            }
        }
        
        Refresh();
        
        
        
        GetAABB = function()
        {
            return {
                xMin: bbox_left,
                yMin: bbox_top,
                zMin: min(z1, z2, z3),
                xMax: bbox_right,
                yMax: bbox_bottom,
                zMax: max(z1, z2, z3),
            };
        }
        
        Draw = function(_color = undefined, _wireframe = undefined)
        {
            __BONK_VERIFY_UGG
            UggTriangle(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
        }
        
        
        
        return self;
    }
}