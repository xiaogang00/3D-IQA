function x = wavelet2(x1,x2)
%[C,S]=wavedec2(x1,2,'db1');
%% The wavelet decomposition of x1 and x2
[A1,H1,V1,D1]=dwt2(x1,'db1');
[A2,H2,V2,D2]=dwt2(x2,'db1');
[row,col]=size(A1);

%% Using the saliency function to compute the weight for left and right view
saliency1 = saliency_SR(A1);
saliency2 = saliency_SR(A2);
sum1=sum(saliency1(:));
sum2=sum(saliency2(:));
w1 = sum1/(sum1+sum2);
w2 = sum2/(sum1+sum2);


%% Fusion the wavelet decomposition of x1 and x2
for i=1:row
    for j=1:col
        % In the Low-frequency, we use the weight computed above.
        A(i,j)=w1*A1(i,j)+w2*A2(i,j);
        % While for the region of H,V,D, we take the principle of max
        % H is the coefficient of decomposition for horizontal direction
        if abs(H1(i,j))>abs(H2(i,j)) 
            H(i,j)=H1(i,j);
        else 
            H(i,j)=H2(i,j);
        end
        % V is the coefficient of decomposition for vertical direction
        if abs(V1(i,j))>abs(V2(i,j))
            V(i,j)=V1(i,j);
        else 
            V(i,j)=V2(i,j);
        end
        % D is the coefficient of decomposition for diagonal
        if abs(D1(i,j))>abs(D2(i,j))  
            D(i,j)=D1(i,j);
        else
            D(i,j)=D2(i,j);
        end
    end
end

%% Rebuild the image
x=idwt2(A,H,V,D,'db1');
end

