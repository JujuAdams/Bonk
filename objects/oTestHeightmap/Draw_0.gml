if ((current_time mod 500) > 250)
{
    shape.DebugDraw();
}
else
{
    UggSetShader();
    vertex_submit(vbuffVolume, pr_trianglelist, -1);
    shader_reset();
}