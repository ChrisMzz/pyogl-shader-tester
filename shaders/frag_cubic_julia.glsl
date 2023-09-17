// julia set chaotic (first shadertoy project)

#version 330 core
in vec2 uv;
uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;
out vec4 fragColor;
//in vec4 iMouse;


void main( )
{
    vec2 fragCoord = uv*iResolution.xy;

    vec2 new_uv = (fragCoord*2. - iResolution.xy)/iResolution.y;

    vec2 z = new_uv*1.2;
    float gr = 0.65+sin(iTime*0.01)*0.05;
    vec2 c = vec2(cos(iTime*0.04), sin(iTime*0.04))*gr;
    float temp;

    vec2 check = (z/z)*2.; // constant that's the same size as z, to allow use of lessThan function
    vec2 esc = check*iter/2; // escape uv
    

    for (int i=0; i<200; i++) {
        
        temp = pow(z.x,3.0) - 3.0*z.x*pow(z.y,2.0) + c.x;
        z.y = 3.0*pow(z.x,2.0)*z.y - pow(z.y,3.0) + c.y;
        z.x = temp;

        esc -= vec2(lessThan(z,check)); // does not work as intended as big values aren't "bigger", just undefined
    }

    esc /= iter; // esc values are between 0 and iter, so they need to be normalized


    // Bernstein
    float R = 9.*(1.-length(esc))*length(esc)*length(esc)*length(esc);
    float G = 27.*(1.-length(esc))*(1.-length(esc))*(1.-length(esc))*length(esc)*length(esc);
    float B = 8.5*(1.-length(esc))*(1.-length(esc))*(1.-length(esc))*length(esc);
    //

    float zmod = sqrt(z.x*z.x + z.y*z.y);

    fragColor = vec4(z.x, z.y, zmod , 1.0);




}