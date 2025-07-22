// Feather disable all

/// @param line
/// @param triangle

function BonkBoolLineInTriangle(_line, _triangle)
{
    with(_line)
    {
        with(_triangle)
        {
            var _vertices = [[x1, y1, z1], [x2, y2, z2], [x3, y3, z3]];
            
            __CalculateNormal();
            var _normal = [normalX, normalY, normalZ];
    	    var _planeDistance = planeDistance;
        }
        
        var _line0 = [x1, y1, z1];
        var _line1 = [x2, y2, z2];
        
    	//Check if the line is parallel to the plane, and early-out if so
    	var _dir = BonkVecSubtract(_line1, _line0);
    	var _n_dot_dir = BonkVecDot(_normal, _dir);
    	if (abs(_n_dot_dir) == 0) return false;
        
    	//Find the point of collision with the triangle's plane
    	var _t = (_planeDistance - BonkVecDot(_normal, _line0)) / _n_dot_dir;
    	if ((_t < 0) || (_t > 1)) return false; //Exit if the point of collision is off the line
        var _p = BonkVecAdd(_line0, BonkVecMultiply(_dir, _t));
        
    	//Check if P is inside the triangle
    	var _c = BonkVecCross(BonkVecSubtract(          _p, _vertices[0]),
    	                      BonkVecSubtract(_vertices[1], _vertices[0]));
    	if (BonkVecDot(_normal, _c) < 0) return false;
        
    	var _c = BonkVecCross(BonkVecSubtract(          _p, _vertices[1]),
    	                      BonkVecSubtract(_vertices[2], _vertices[1]));
    	if (BonkVecDot(_normal, _c) < 0) return false;
        
    	var _c = BonkVecCross(BonkVecSubtract(          _p, _vertices[2]),
    	                      BonkVecSubtract(_vertices[0], _vertices[2]));
    	if (BonkVecDot(_normal, _c) < 0) return false;
        
        //FIXME - Return actual collision information
        return true;
    }
}