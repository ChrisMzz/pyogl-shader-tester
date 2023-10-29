#version 330 core
in vec2 uv;
uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;
uniform vec2 center;
uniform float zoom_amount;
uniform int colouring;
out vec4 fragColor;



vec3 map(in float t)
{
    vec3 rgb;

    // all colourings
    if (colouring == 1)
    {
        // At sea
        rgb = vec3(
        9.93*pow(t,3.8)*pow((1.-t),0.9),
        12.95*pow(t,2.8)*pow((1.-t),1.3),
        20.67*pow(t,1.8)*pow((1.-t),2.7)
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float((0.<=t)&&(t<=1.)));
        //
    }
    else if (colouring == 2)
    {
        // Ice blue
        rgb = vec3(
        70.5*pow(t,4.7)*pow((1.-t),2.6),
        10.18*pow(t,2.8)*pow((1.-t),1.1),
        2.6*pow(t,0.8)*pow((1.-t),0.5)
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float((0.<=t)&&(t<=1.)));
        //
    }
    else if (colouring == 3)
    {
        // Yellow and Purple
        rgb = vec3(
        1.68*pow(t,0.2)*pow((1.-t),0.9),
        42.35*pow(t,1.9)*pow((1.-t),4.1),
        4.61*pow(t,1.6)*pow((1.-t),0.8)
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float((0.<=t)&&(t<=1.)));
        //
    }
    else if (colouring == 4)
    {
        // Earth
        rgb = vec3(
        5.76*pow(t,0.7)*pow((1.-t),2.8),
        6.49*pow(t,1.3)*pow((1.-t),1.4),
        exp(-9.*pow(t-0.8,2.))
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float(t>=0.));
        //
    }
    else if (colouring == 5)
    {
        // Cyan and Magenta decay
        rgb = vec3(
        2*exp(-10.*pow(t-0.2,2.))*pow(t,0.6),
        exp(-20.*pow(t-0.7,2.)),
        exp(-5.*pow(t-0.5,2.))
        );
        rgb = vec3(rgb.x,rgb.y,rgb.z);
        //
    }
    else if (colouring == 6)
    {
        // Emergency exit
        rgb = vec3(
        1.68*pow(t,0.2)*pow((1.-t),0.9)*(1-pow((sin(iTime*2.)+1.)/2.,3.)),
        12.06*pow(t,1.9)*pow((1.-t),1.7),
        1.61*pow(t,1.6)*pow((1.-t),0.8)
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float((0.<=t)&&(t<=1.)));
        //
    }
    else if (colouring == 7)
    {
        // Inverted lightness RGB
        rgb = vec3(
        t+0.2*sin(iTime*0.1)-0.2,
        t+0.2*sin(2.+iTime*0.1)-0.2,
        t+0.2*sin(3.+iTime*0.1)-0.2
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.))+float(t>=1.),rgb.y*float((0.<=t)&&(t<=1.))+float(t>=1.),rgb.z*float((0.<=t)&&(t<=1.))+float(t>=1.));
        //
    }
    else if (colouring == 8)
    {
        // Literature
        rgb = vec3(
        7.79*pow(t,1.7)*pow((1.-t),1.3),
        10.18*pow(t,2.8)*pow((1.-t),1.1),
        50.9*pow(t,1.8)*pow((1.-t),5.0)
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float((0.<=t)&&(t<=1.)));
        //
    }

    else
    // Default (0)
    {
        rgb = vec3(
        8.5*pow(t,3.0)*pow((1.-t),1.0),
        15.*pow(t,2.0)*pow((1.-t),2.0),
        9.*pow(t,1.)*pow((1.-t),3.0)
        );
        rgb = vec3(rgb.x*float((0.<=t)&&(t<=1.)),rgb.y*float((0.<=t)&&(t<=1.)),rgb.z*float((0.<=t)&&(t<=1.)));
        //
    }

    return rgb;

}


vec3 hsl2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}

void main( )
{
    vec2 fragCoord = uv*iResolution.xy; // this creates an equivalent to ShaderToy's fragCoord variable
    vec2 new_uv = (fragCoord*2. - iResolution.xy)/iResolution.y; // centered


    vec2 z = new_uv*zoom_amount+center;
    //float gr = 0.65+sin(iTime*0.01)*0.05; //varying circle radii
    //vec2 c = vec2(cos(iTime*0.04), sin(iTime*0.04))*gr; // complex variable c going in circles around origin
    
    // fixed
    //vec2 c = vec2(-0.8,0.156);
    //vec2 c = vec2(((iMouse.x/iResolution.x)*2.-1.)*2*zoom_amount*(iResolution.x/(2.*iResolution.y))-center.x, ((-(iMouse.y/iResolution.y)+1.)*2.-1.)*zoom_amount)-center.y;
    vec2 c = vec2(-0.945, -0.275);
    //vec2 c = vec2(-0.5,0.);

    /*
        Compute iter iterates of f on the rendered complex plane
        z.x should always be overwritten to real part of f(z),
        z.y should always be overwritten to imaginary part of f(z).
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

        /* test
        z = vec2(
        pow(z.x,4.0)-6.*pow(z.y,2.0)*pow(z.x,2.0)+pow(z.y,4.0)+c.x,
        -4.*z.x*pow(z.y,3.0)+4.*z.y*pow(z.x,3.0)+c.y
        );
        */


        esc -= vec2(lessThan(z,check)); // does not work as intended as big values aren't "bigger", just undefined
    }

    esc /= iter; // esc values are between 0 and iter, so they need to be normalized

    float zmod = sqrt(z.x*z.x + z.y*z.y);
    float angle = atan(z.y/z.x);
    
    // smooth colouring using modified Bernstein equations
    float t = length(esc);
    vec3 RGB = map(t);

    // iMouse.x/iResolution.x //
    // iMouse.y/iResolution.y //
    // how close the mouse is to the right / bottom edge of the screen between [0,1]

    // RGB = RGB + hsl2rgb(vec3(angle, 0.3, zmod));

    fragColor = vec4(RGB, 1.0);


}