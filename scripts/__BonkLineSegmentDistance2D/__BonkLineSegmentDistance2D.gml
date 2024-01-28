function __BonkLineSegmentDistance2D(_xA0, _yA0,   _xA1, _yA1,   _xB0, _yB0,   _xB1, _yB1)
{
    static _result = {};
    
    var _dxR = _xB0 - _xA0;
    var _dyR = _yB0 - _yA0;
    
    var _dxU = _xA1 - _xA0;
    var _dyU = _yA1 - _yA0;
    
    var _dxV = _xB1 - _xB0;
    var _dyV = _yB1 - _yB0;
    
    var _dotRU = dot_product(_dxR, _dyR,   _dxU, _dyU);
    var _dotRV = dot_product(_dxR, _dyR,   _dxV, _dyV);
    var _dotUU = dot_product(_dxU, _dyU,   _dxU, _dyU);
    var _dotUV = dot_product(_dxU, _dyU,   _dxV, _dyV);
    var _dotVV = dot_product(_dxV, _dyV,   _dxV, _dyV);
    
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
    var _T = clamp((_s*_dotUV + _dotRV) / _dotVV, 0, 1);
    
    var _outXA = _xA0 + _S*_dxU;
    var _outYA = _yA0 + _S*_dyU;
    
    var _outXB = _xB0 + _T*_dxV;
    var _outYB = _yB0 + _T*_dyV;
    
    _result.xA = _outXA;
    _result.yA = _outYA;
    
    _result.xB = _outXB;
    _result.yB = _outYB;
    
    _result.distance = point_distance(_outXA, _outYA,   _outXB, _outYB);
    
    return _result;
}