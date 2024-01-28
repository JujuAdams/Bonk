// Feather disable all

function __BonkCrossProduct(_xA, _yA, _zA, _xB, _yB, _zB)
{
    static _result = {};
    _result.x = _zA*_yB - _yA*_zB;
    _result.y = _xA*_zB - _zA*_xB;
    _result.z = _yA*_xB - _xA*_yB;
    return _result;
}