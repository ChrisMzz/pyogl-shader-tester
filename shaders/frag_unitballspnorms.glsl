// julia set chaotic (first shadertoy project)

#version 330 core
in vec2 uv;
uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;
out vec4 fragColor;


void main( )
{
    vec2 fragCoord = uv*iResolution.xy; // this creates an equivalent to ShaderToy's fragCoord variable
    vec2 new_uv = (fragCoord*2. - iResolution.xy)/iResolution.y; // centered

    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    /*
    float x = sin(iTime*0.2)*pow(max(length(new_uv.x),length(new_uv.y)),3.);
    float y = sin(iTime*0.2+2)*pow(length(length(new_uv.x)+length(new_uv.y)),3.);
    float z = sin(iTime*0.2+4)*pow(length(new_uv),3.);
    */
    float t = iTime*0.1;
    float x = pow(pow(length(new_uv.x),t)+pow(length(new_uv.y),t),6/t);


    fragColor = vec4(x, 0., 0., 1.0);

}