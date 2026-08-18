// Feather disable all

/// @param [color=white]

function UggSetWireframeShader(_color = c_white)
{
    static _shdUggWireframe_u_vColor = shader_get_uniform(__shdUggWireframe, "u_vColor");
    
    shader_set(__shdUggWireframe);
    shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(_color), color_get_green(_color), color_get_blue(_color));
}