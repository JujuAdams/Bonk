function __BonkLineSegmentDistance3D(_xA0, _yA0, _zA0,   _xA1, _yA1, _zA1,   _xB0, _yB0, _zB0,   _xB1, _yB1, _zB1)
{
    static _result = {};
    
    var _dxR = _xB0 - _xA0;
    var _dyR = _yB0 - _yA0;
    var _dzR = _zB0 - _zA0;
    
    var _dxU = _xA1 - _xA0;
    var _dyU = _yA1 - _yA0;
    var _dzU = _zA1 - _zA0;
    
    var _dxV = _xB1 - _xB0;
    var _dyV = _yB1 - _yB0;
    var _dzV = _zB1 - _zB0;
    
    var _dotRU = dot_product_3d(_dxR, _dyR, _dzR,   _dxU, _dyU, _dzU);
    var _dotRV = dot_product_3d(_dxR, _dyR, _dzR,   _dxV, _dyV, _dzV);
    var _dotUU = dot_product_3d(_dxU, _dyU, _dzU,   _dxU, _dyU, _dzU);
    var _dotUV = dot_product_3d(_dxU, _dyU, _dzU,   _dxV, _dyV, _dzV);
    var _dotVV = dot_product_3d(_dxV, _dyV, _dzV,   _dxV, _dyV, _dzV);
    
    var _determinant = _dotUU*_dotVV - _dotUV*_dotUV;
    
    if (_determinant < 0.00001*_dotUU*_dotVV)
    {
        var _s = clamp(_dotRU / _dotUU, 0, 1);
        var _t = 0;
    }
    else
    {
        var _s = clamp((_dotRU*_dotVV - _dotRV*_dotUV) / _determinant, 0, 1);
        var _t = clamp((_dotRU*_dotUV - _dotRV*_dotUU) / _determinant, 0, 1);
    }
    
    var _S = clamp((_t*_dotUV + _dotRU) / _dotUU, 0, 1);
    var _T = clamp((_s*_dotUV - _dotRV) / _dotVV, 0, 1);
    
    var _outXA = _xA0 + _S*_dxU;
    var _outYA = _yA0 + _S*_dyU;
    var _outZA = _zA0 + _S*_dzU;
    
    var _outXB = _xB0 + _T*_dxV;
    var _outYB = _yB0 + _T*_dyV;
    var _outZB = _zB0 + _T*_dzV;
    
    _result.xA = _outXA;
    _result.yA = _outYA;
    _result.zA = _outZA;
    
    _result.xB = _outXB;
    _result.yB = _outYB;
    _result.zB = _outZB;
    
    _result.distance = point_distance_3d(_outXA, _outYA, _outZA,   _outXB, _outYB, _outZB);
    
    return _result;
}

/*
local eta = 1e-6
local function nearestPointsOnLineSegments(a0, a1, b0, b1)
    local r = b0 - a0
    local u = a1 - a0
    local v = b1 - b0

    local ru = r:Dot(u)
    local rv = r:Dot(v)
    local uu = u:Dot(u)
    local uv = u:Dot(v)
    local vv = v:Dot(v)

    local det = uu*vv - uv*uv
    local s, t

    if det < eta*uu*vv then
        s = math.clamp(ru/uu, 0, 1)
        t = 0
    else
        s = math.clamp((ru*vv - rv*uv)/det, 0, 1)
        t = math.clamp((ru*uv - rv*uu)/det, 0, 1)
    end

    local S = math.clamp((t*uv + ru)/uu, 0, 1)
    local T = math.clamp((s*uv - rv)/vv, 0, 1)

    local A = a0 + S*u
    local B = b0 + T*v
    return A, B, (B - A):Length()
end

*/