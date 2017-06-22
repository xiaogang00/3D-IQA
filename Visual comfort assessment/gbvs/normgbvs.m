function [ out ] = normgbvs( scr )

[m,n]= size(scr);
sig=n/10;
out=zeros(m*n,m*n);
for i=1:m*n
    x1=ceil(i/n);y1=i-n*(x1-1);
    for j=i:m*n
        x2=ceil(j/n);y2=j-n*(x2-1);
        out(i,j)=scr(x2,y2)*exp(-((x1-x2).^2+(y1-y2).^2)/(2*sig.^2));
        out(j,i)=scr(x1,y1)*exp(-((x1-x2).^2+(y1-y2).^2)/(2*sig.^2));
    end
end

%normalize every row to 1
for i=1:m*n
    rowsum=sum(out,2);
    out(i,:)=out(i,:)/rowsum(i,1);
end

end

