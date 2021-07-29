/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param radius
/// @param tx1
/// @param ty1
/// @param tz1
/// @param tx2
/// @param ty2
/// @param tz2
/// @param tx3
/// @param ty3
/// @param tz3

function BonkCapsuleTriangleIntersection(_capsule_x1, _capsule_y1, _capsule_z1, _capsule_x2, _capsule_y2, _capsule_z2, _capsule_radius, _tri_x1, _tri_y1, _tri_z1, _tri_x2, _tri_y2, _tri_z2, _tri_x3, _tri_y3, _tri_z3)
{
    //Similar to the solution three.js uses
    
    //Calculate the triangle's plane (defined here as a normal and a distance from the origin)
    var _dx12 = _tri_x2 - _tri_x1;
    var _dy12 = _tri_y2 - _tri_y1;
    var _dz12 = _tri_z2 - _tri_z1;
    
    var _dx13 = _tri_x3 - _tri_x1;
    var _dy13 = _tri_y3 - _tri_y1;
    var _dz13 = _tri_z3 - _tri_z1;
    
    //FIXME - Normal's backwards, probably a handedness issue
    var _nx = -(_dz12*_dy13 - _dy12*_dz13);
    var _ny = -(_dx12*_dz13 - _dz12*_dx13);
    var _nz = -(_dy12*_dx13 - _dx12*_dy13);
    
    var _d = 1 / sqrt(_nx*_nx + _ny*_ny + _nz*_nz);
    _nx *= _d;
    _ny *= _d;
    _nz *= _d;
    
    var _plane_distance = _tri_x1*_nx + _tri_y1*_ny + _tri_z1*_nz;
    
    //Find how far away the capsule's end points are from the plane
    var _distance1 = (_capsule_x1*_nx + _capsule_y1*_ny + _capsule_z1*_nz) - _plane_distance - _capsule_radius;
    var _distance2 = (_capsule_x2*_nx + _capsule_y2*_ny + _capsule_z2*_nz) - _plane_distance - _capsule_radius;
        
    if (((_distance1 > 0) && (_distance2 > 0)) || ((_distance1 < -2*_capsule_radius) && (_distance2 < -2*_capsule_radius)))
    {
        return false;
    }
    
    var _t = abs(_distance1 / (abs(_distance1) + abs(_distance2)));
    var _ix = _capsule_x1 + _t*(_capsule_x2 - _capsule_x1);
    var _iy = _capsule_y1 + _t*(_capsule_y2 - _capsule_y1);
    var _iz = _capsule_z1 + _t*(_capsule_z2 - _capsule_z1);
    
    if (BonkTriangleContainsPoint(_ix, _iy, _iz,
                                  _tri_x1, _tri_y1, _tri_z1,
                                  _tri_x2, _tri_y2, _tri_z2,
                                  _tri_x3, _tri_y3, _tri_z3))
    {
        return true;
    }
        
    var _min_points = __BonkSegmentSegmentMinimumPoints(_capsule_x1, _capsule_y1, _capsule_z1,
                                                        _capsule_x2, _capsule_y2, _capsule_z2,
                                                        _tri_x1, _tri_y1, _tri_z1,
                                                        _tri_x2, _tri_y2, _tri_z2);
    var _distance = point_distance_3d(_min_points[0], _min_points[1], _min_points[2], _min_points[3], _min_points[4], _min_points[5]);
    if (_distance < _capsule_radius) return true;
        
    var _min_points = __BonkSegmentSegmentMinimumPoints(_capsule_x1, _capsule_y1, _capsule_z1,
                                                        _capsule_x2, _capsule_y2, _capsule_z2,
                                                        _tri_x2, _tri_y2, _tri_z2,
                                                        _tri_x3, _tri_y3, _tri_z3);
    var _distance = point_distance_3d(_min_points[0], _min_points[1], _min_points[2], _min_points[3], _min_points[4], _min_points[5]);
    if (_distance < _capsule_radius) return true;
        
    var _min_points = __BonkSegmentSegmentMinimumPoints(_capsule_x1, _capsule_y1, _capsule_z1,
                                                        _capsule_x2, _capsule_y2, _capsule_z2,
                                                        _tri_x3, _tri_y3, _tri_z3,
                                                        _tri_x1, _tri_y1, _tri_z1);
    var _distance = point_distance_3d(_min_points[0], _min_points[1], _min_points[2], _min_points[3], _min_points[4], _min_points[5]);
    if (_distance < _capsule_radius) return true;
        
    return false;
}

function BonkTriangleContainsPoint(_px, _py, _pz, _tri_x1, _tri_y1, _tri_z1, _tri_x2, _tri_y2, _tri_z2, _tri_x3, _tri_y3, _tri_z3)
{
	var _barycentric = BonkTriangleGetBarycentricCoordinates(_px, _py, _pz, _tri_x1, _tri_y1, _tri_z1, _tri_x2, _tri_y2, _tri_z2, _tri_x3, _tri_y3, _tri_z3);
	return ((_barycentric[0] >= 0 ) && (_barycentric[1] >= 0 ) && (_barycentric[0] + _barycentric[1] <= 1));
}

function BonkTriangleGetBarycentricCoordinates(_px, _py, _pz, _tri_x1, _tri_y1, _tri_z1, _tri_x2, _tri_y2, _tri_z2, _tri_x3, _tri_y3, _tri_z3)
{
    var _v0x = _tri_x3 - _tri_x1;
    var _v0y = _tri_y3 - _tri_y1;
    var _v0z = _tri_z3 - _tri_z1;
    
    var _v1x = _tri_x2 - _tri_x1;
    var _v1y = _tri_y2 - _tri_y1;
    var _v1z = _tri_z2 - _tri_z1;
    
    var _v2x = _px - _tri_x1;
    var _v2y = _py - _tri_y1;
    var _v2z = _pz - _tri_z1;
    
    var _dot00 = _v0x*_v0x + _v0y*_v0y + _v0z*_v0z;
    var _dot01 = _v0x*_v1x + _v0y*_v1y + _v0z*_v1z;
    var _dot02 = _v0x*_v2x + _v0y*_v2y + _v0z*_v2z;
    var _dot11 = _v1x*_v1x + _v1y*_v1y + _v1z*_v1z;
    var _dot12 = _v1x*_v2x + _v1y*_v2y + _v1z*_v2z;
    
    var _denominator = _dot00*_dot11 - _dot01*_dot01;
    if (_denominator == 0) return [-1, -1, -1];
    
    var _u = (_dot11*_dot02 - _dot01*_dot12) / _denominator;
    var _v = (_dot00*_dot12 - _dot01*_dot02) / _denominator;
    
    return [1 - _u - _v, _v, _u];
}

function __BonkSegmentSegmentMinimumPoints(_ax, _ay, _az,    _bx, _by, _bz,    _cx, _cy, _cz,    _dx, _dy, _dz)
{
    //https://zalo.github.io/blog/closest-point-between-segments/
    
    var _ab_x = _bx - _ax,    _ab_y = _by - _ay,    _ab_z = _bz - _az;
    var _cd_x = _dx - _cx,    _cd_y = _dy - _cy,    _cd_z = _dz - _cz;
    var _ab_sqr_length = _ab_x*_ab_x + _ab_y*_ab_y + _ab_z*_ab_z;
    var _cd_sqr_length = _cd_x*_cd_x + _cd_y*_ab_y + _cd_z*_cd_z;
    
    var _ac_x = _ax - _cx,    _ac_y = _ay - _cy,    _ac_z = _az - _az;
    var _bc_x = _bx - _cx,    _bc_y = _by - _cy,    _bc_z = _cz - _az;
    
    var _coeff = (_ac_x*_cd_x + _ac_y*_cd_y + _ac_z*_cd_z) / _cd_sqr_length;
    var _px = _ax + _cd_x*_coeff, _py = _ay + _cd_y*_coeff, _pz = _az + _cd_z*_coeff;
    
    var _coeff = (_bc_x*_cd_x + _bc_y*_cd_y + _bc_z*_cd_z) / _cd_sqr_length;
    var _qx = _bx + _cd_x*_coeff, _qy = _by + _cd_y*_coeff, _qz = _bz + _cd_z*_coeff;
    
    var _pq_x = _qx - _px,    _pq_y = _qy - _py,    _pq_z = _qz - _pz;
    
    var _pq_spr_length = _pq_x*_pq_x + _pq_y*_pq_y + _pq_z*_pq_z;
    if (_pq_spr_length == 0)
    {
        var _t = 0;
    }
    else
    {
        var _pc_x = _cx - _px,    _pc_y = _cy - _py,    _pc_z = _cz - _pz;
        var _t = (_pc_x*_pq_x + _pc_y*_pq_y + _pc_z*_pq_z) / _pq_spr_length;
    }
      
    var _rx = _ax + _t*_ab_x,    _ry = _ay + _t*_ab_y,    _rz = _az + _t*_ab_z;
    
    var _cr_x = _rx - _cx,    _cr_y = _ry - _cy,    _cr_z = _rz - _cz;
    var _t = clamp((_cr_x*_cd_x + _cr_y*_cd_y + _cr_z*_cd_z) / _cd_sqr_length, 0, 1);
    var _ux = _cx + _t*_cd_x,    _uy = _cy + _t*_cd_y,    _uz = _cz + _t*_cd_z;
    
    var _au_x = _ux - _ax,    _au_y = _uy - _ay,    _au_z = _uz - _az;
    var _s = clamp((_au_x*_ab_x + _au_y*_ab_y + _au_z*_ab_z) / _ab_sqr_length, 0, 1);
    var _vx = _ax + _s*_ab_x,    _vy = _ay + _s*_ab_y,    _vz = _az + _s*_ab_z;
    
    return [ _ux, _uy, _uz,    _vx, _vy, _vz ];
}