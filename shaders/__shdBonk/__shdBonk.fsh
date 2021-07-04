varying vec4 v_vColour;
varying vec3 v_vNormal;

uniform vec3 u_vAmbientColor;
uniform vec3 u_vDirectLightColor;
uniform vec3 u_vDirectLightDirection;

void main()
{
    gl_FragColor = v_vColour;
    
    gl_FragColor.rgb *= min(vec3(1.0), u_vAmbientColor + u_vDirectLightColor*max(0.0, dot(-v_vNormal, u_vDirectLightDirection)));
}