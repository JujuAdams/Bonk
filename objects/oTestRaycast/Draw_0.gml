// Feather disable all

var _i = 0;
repeat(array_length(pointArrayA) div 3)
{
    var _x = gridScale*(pointArrayA[_i  ] + 0.5);
    var _y = gridScale*(pointArrayA[_i+1] + 0.5);
    var _z = gridScale*(pointArrayA[_i+2] + 0.5);
    
    UggAABB(_x, _y, _z,
            gridScale, gridScale, gridScale,
            c_blue, true);
    
    UggSphere(_x, _y, _z, 2, c_white);
    
    _i += 3;
}

UggArrow(gridScale*lineA.x1, gridScale*lineA.y1, gridScale*lineA.z1,
         gridScale*lineA.x2, gridScale*lineA.y2, gridScale*lineA.z2,
         undefined, c_yellow);

world.Draw();
lineB.Draw();

hit = lineB.Hit(world);
if (hit.shape != undefined)
{
    UggSphere(hit.x, hit.y, hit.z, 3, c_red);
}