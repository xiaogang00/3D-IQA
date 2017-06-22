function [ out ] = geteqdis( scr,iters,m,n)

vec=ones(1,m*n);
vec=vec./(m*n);
for i=1:iters
    old=vec*scr;
    vec=old;
end
vec=vec./(sum(vec));

% tranform vector to matrix
out=zeros(m,n);
for i=1:m
    for j=1:n
        out(i,j)=vec(1,n*(i-1)+j);
    end
end

end

