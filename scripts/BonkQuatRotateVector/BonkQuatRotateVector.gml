function BonkQuatRotateVector(_quat, _x, _y, _z)
{
    var _result = BonkQuatMultiply([_x, _y, _z, 0], quat);
    
    _result[@ 0] *= -1;
    _result[@ 1] *= -1;
    _result[@ 2] *= -1;
    _result[@ 3]  =  0;
    
    _result = BonkQuatMultiply(_result, _quat);
    
    array_resize(_result, 3);
    return _result;
}