// Feather disable all

function D3RandomVector()
{
    static _result = {
        x: 0,
        y: 0,
        z: 0,
    };
    
    //FIXME - Use safe random number
    var _theta  = random_range(0, 360);
    var _phi    = random_range(0, 360);
    var _u      = dcos(_phi);
    var _uTrans = sqrt(1 - _u*_u);
    
    with(_result)
    {
        x = _uTrans*dcos(_theta);
        y = _uTrans*dsin(_theta);
        z = _u;
    }
    
    return _result;
}