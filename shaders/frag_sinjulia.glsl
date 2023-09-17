

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

    vec2 z = new_uv*1.2;
    float gr = 0.65+sin(iTime*0.01)*0.05; //varying circle radii
    vec2 c = vec2(cos(iTime*0.04), sin(iTime*0.04))*gr; // complex variable c going in circles around origin
    

    /*
        Compute iter iterates of f on the rendered complex plane
        z.x should always be overwritten to real part of f(z),
        z.y should always be overwritten to imaginary part of f(z).
        
        Somehow found way to code an escape uv ? Could allow me to use Bernstein type colourings.
    */

    int iter = 200;

    vec2 esc = z*iter; // escape uv
    vec2 check = (z/z)*2.; // constant that's the same size as z, to allow use of lessThan function
    
    for (int i=0; i<iter; i++) {
        z = vec2(
        0.5*(cos(z.y)*(exp(z.x)+exp(-z.x))), 0.5*(sin(z.y)*(exp(z.x)-exp(-z.x)))
        );
        esc -= vec2(lessThan(z,check)); // does not work as intended as big values aren't "bigger", just undefined
    }

    esc /= iter; // esc values are between 0 and iter, so they need to be normalized

    float zmod = sqrt(z.x*z.x + z.y*z.y);
    float angle = atan(z.y/z.x);
    
    /* Bernstein
    float R = 9.*(1.-esc)*esc*esc*esc;
    float G = 15.*(1.-esc)*(1.-esc)*esc*esc;
    float B = 8.5*(1.-esc)*(1.-esc)*(1.-esc)*esc;
    */

    // iMouse.x/iResolution.x //
    // iMouse.y/iResolution.y //
    // how close the mouse is to the right / bottom edge of the screen between [0,1]

    fragColor = vec4(z.x, z.y, zmod, 1.0);


}