// Feather disable all

hit = line.Hit(shape);
if (hit.shape != undefined)
{
    UggSphere(hit.x, hit.y, hit.z, 3, c_red);
}