function gabor_k = compute(x,y,f0,theta)
r = 1; g = 1;
x1 = x*cos(theta) + y*sin(theta);
y1 = -x*sin(theta) + y*cos(theta);
gabor_k = f0^2/(pi*r*g)*exp(-(f0^2*x1^2/r^2+f0^2*y1^2/g^2))*exp(i*2*pi*f0*x1); 

