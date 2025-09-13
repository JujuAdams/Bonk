// Feather disable all

/// Sets the current shader to Ugg's native volume rendering shader. This function is provided for
/// convenience when testing whitebox graphics and using this function is entirely optional (Ugg
/// shape-drawing functions will set the correct shader themselves).
/// 
/// @param [color=white]

function UggSetShader(_color = c_white)
{
    static _shdUggVolume_u_vColor = shader_get_uniform(__shdUggVolume, "u_vColor");
    
    shader_set(__shdUggVolume);
    shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(_color), color_get_green(_color), color_get_blue(_color));
}