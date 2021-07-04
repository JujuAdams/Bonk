attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec3 in_Normal;

varying vec4 v_vColour;
varying vec3 v_vNormal;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position, 1.0);
    
    v_vColour = in_Colour;
    v_vNormal = in_Normal;
}
