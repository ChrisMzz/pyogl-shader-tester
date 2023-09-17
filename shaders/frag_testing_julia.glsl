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

    vec2 new_uv0 = new_uv;

    //uv = sin(acos(1.0)*uv);
    new_uv = (fract(new_uv*3.)-0.5)*3.;
    
    

    // Time varying pixel color
    float x = new_uv.x;
    float y = new_uv.y;

    float Acx = cos(iTime*0.3)/2.-0.1;
    float Acy = sin(iTime*0.3)/2.-0.1;

    float cx = sin(iTime*0.25)/2.-0.1;
    float cy = cos(iTime*0.25)/2.+0.1;
    
    float tempX;
    float Lx = x;
    float Ly = y;
    float Rx = x;
    float Ry = y;
    
    for (int i=0; i<200; i++) {
        
        tempX = pow(Lx,3.0) - 3.0*Lx*pow(Ly,2.0) + Acx;
        Ly = 3.0*pow(Lx,2.0)*Ly - pow(Ly,3.0) + cy;
        Lx = tempX;
        
    }

    
    for (int i=0; i<200; i++) {
        
        tempX = pow(Rx,3.0) - 3.0*Rx*pow(Ry,2.0) + cx;
        Ry = 3.0*pow(Rx,2.0)*Ry - pow(Ry,3.0) + Acy;
        Rx = tempX;
        
    }

    
    
    Lx *= 0.1*(length(new_uv)-sin(iTime))-sin(iTime*0.03);
    Ly *= 0.1*(length(new_uv)-cos(iTime));
    Rx *= 0.1*(length(new_uv)-sin(iTime));
    Ry *= 0.1*(length(new_uv)-cos(iTime))+cos(iTime*0.04);
    
    
    
    float finalX = new_uv0.x;
    float finalY = new_uv0.y;
    vec2 dropoff = vec2(new_uv0.x, new_uv0.y);
    
    for (int i=0; i<200; i++) {
        
        tempX = pow(finalX,2.0) - pow(finalY,2.0) + (Lx+Rx)/2.0;
        finalY = 2.0*finalX*finalY + (Ly+Ry)/2.0;
        finalX = tempX;
        
    }
    
    // final operation to remove sharp edges
    tempX = pow(finalX,2.0) - pow(finalY,2.0);
    finalY = 2.0*finalX*finalY;
    finalX = tempX;
    
    
    float Ld = length(new_uv0) - sqrt(pow(Lx,2.0) + pow(Ly,2.0))*2.0;
    float Rd = length(new_uv0) - sqrt(pow(Rx,2.0) + pow(Ry,2.0))*2.0;
    
    
    
    float G = length(new_uv0);
    float R = sin(iTime*0.02)*0.5+0.5+finalX + Ld;
    float B = finalY + G*sin(iTime) + Rd;

    vec4 newColor = vec4(R,R*B+(Ld+Rd)*cos(iTime*0.05),sin(iTime*0.06)*0.5+0.5-B,1.0);
    
    fragColor = newColor;
    
}

