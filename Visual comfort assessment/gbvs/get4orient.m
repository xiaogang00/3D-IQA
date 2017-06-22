function [ out ] = get4orient( scr )

f0 = 0.2; 
count =0;
out=cell(1,4);
m=1;
for theta = [0,pi/4,pi/2,pi*3/4];%”√ª°∂»0,pi/4,pi/2,pi*3/4
    count = count + 1;
    x = 0;
    for i = linspace(-8,8,11)
        x = x + 1;
        y = 0;
        for j = linspace(-8,8,11)
            y = y + 1;
            z(y,x)=compute(i,j,f0,theta);
        end
    end

     filtered = filter2(z,scr,'same');
     f = abs(filtered);
     f=f/max(f(:));
     out{1,m}=f;
     m=m+1;
end

end

