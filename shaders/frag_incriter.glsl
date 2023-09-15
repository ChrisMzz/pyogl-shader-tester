// julia set chaotic (first shadertoy project)

#version 330 core
in vec2 uv;
uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;
out vec4 fragColor;

// follows mouse


void main( )
{
    vec2 fragCoord = uv*iResolution.xy; // this creates an equivalent to ShaderToy's fragCoord variable
    vec2 new_uv = (fragCoord*2. - iResolution.xy)/iResolution.y; // centered

    vec2 z = new_uv*1.2;
    //float gr = 0.65+sin(iTime*0.01)*0.05; //varying circle radii
    //vec2 c = vec2(cos(iTime*0.04), sin(iTime*0.04))*gr; // complex variable c going in circles around origin
    
    //vec2 c = vec2(0.385,0.138);
    vec2 c = vec2((iMouse.x/iResolution.x)*2.-1., -(iMouse.y/iResolution.y)*2.+1.);


    /*
        Compute iter iterates of f on the rendered complex plane
        z.x should always be overwritten to real part of f(z),
        z.y should always be overwritten to imaginary part of f(z).
        
        Somehow found way to code an escape uv ? Could allow me to use Bernstein type colourings.
    */

    int iter = int(iTime*10.);
    //int iter = 200;


    vec2 check = (z/z)*2.; // constant that's the same size as z, to allow use of lessThan function
    vec2 esc = check*iter/2; // escape uv
    
    for (int i=0; i<iter; i++) {

        /* z**2 + c
        z = vec2(
        pow(z.x,2.0) - pow(z.y,2.0) + c.x,
        2.0*z.x*z.y + c.y
        );
        */

        /* sin(z)
        z = vec2(
        0.5*(cos(z.y)*(exp(z.x)+exp(-z.x))) + c.x, 
        0.5*(sin(z.y)*(exp(z.x)-exp(-z.x))) + c.y
        );
        */

        // shuriken
        z = vec2(
        z.x*exp(sin(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)-exp(-2.*z.x*z.y)))*cos(cos(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)+exp(-2.*z.x*z.y))) - z.y*exp(sin(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)-exp(-2.*z.x*z.y)))*sin(cos(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)+exp(-2.*z.x*z.y))) + c.x,
        z.y*exp(sin(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)-exp(-2.*z.x*z.y)))*cos(cos(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)+exp(-2.*z.x*z.y))) + z.x*exp(sin(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)-exp(-2.*z.x*z.y)))*sin(cos(z.x*z.x-z.y*z.y)*(exp(2.*z.x*z.y)+exp(-2.*z.x*z.y))) + c.y
        );
        //

        /* z**3 + c
        z = vec2(
        pow(z.x,3.0) - 3.0*z.x*pow(z.y,2.0) + c.x,
        3.0*pow(z.x,2.0)*z.y - pow(z.y,3.0) + c.y
        );
        */


        esc -= vec2(lessThan(z,check)); // does not work as intended as big values aren't "bigger", just undefined
    }

    esc /= iter; // esc values are between 0 and iter, so they need to be normalized

    float zmod = sqrt(z.x*z.x + z.y*z.y);
    float angle = atan(z.y/z.x);
    
    // Bernstein
    float R = 9.*(1.-length(esc))*length(esc)*length(esc)*length(esc);
    float G = 27.*(1.-length(esc))*(1.-length(esc))*(1.-length(esc))*length(esc)*length(esc);
    float B = 8.5*(1.-length(esc))*(1.-length(esc))*(1.-length(esc))*length(esc);
    //

    // iMouse.x/iResolution.x //
    // iMouse.y/iResolution.y //
    // how close the mouse is to the right / bottom edge of the screen between [0,1]

    fragColor = vec4(R,G,B, 1.0);


}