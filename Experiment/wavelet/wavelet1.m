function img = wavelet1(img1,img2)
%This function can be uesd to computed the first rank and second rank of 
%wavelet coefficient for each image.
%And then based on the principle of fusion for low and high frequency 
%respectively, we can get the new wavelet coefficient. At last, we
%reconstruct the image by idwt2
%Inputs:
%   img1  = the first image for fusion
%   img2  = the second image for fusion
%
% Outputs:
%   img = the result of fusion
%% The wavelet decomposition of x1 and x2
[A1,H1,V1,D1]=dwt2(img1,'db1');
[A2,H2,V2,D2]=dwt2(img2,'db1');
[row,col]=size(A1);

%% Using the saliency function to compute the weight for left and right view
%Compute the saliency map for low frequency wavelet map
saliency1 = saliency_SR(A1);
saliency2 = saliency_SR(A2);

%Compute the weight for each image
% sum1=sum(saliency1(:));
% sum2=sum(saliency2(:));
% w1 = sum1/(sum1+sum2);
% w2 = sum2/(sum1+sum2);

%decompose the second coefficient of low frequency
[C1,S1] = wavedec2(img1,2,'db1');
[C2,S2] = wavedec2(img2,2,'db1');

%The coffection for second rank low frequency
coefl2 = appcoef2(C1,S1,'db1',2);
coefr2 = appcoef2(C2,S2,'db1',2);
[row2, col2] = size(coefl2);

%extract the saliency map of the new wavelet map
saliency_coefl = saliency_SR(coefl2);
saliency_coefr = saliency_SR(coefr2);

%Compute the weight of the second rank low-frequancy wavelet map for fusion
% sum3 = sum(saliency_coefl(:));
% sum4 = sum(saliency_coefr(:));
% w3 = sum3 / (sum3 + sum4);
% w4 = sum4/  (sum3 + sum4);


%% Fusion the wavelet decomposition of x1 and x2
for i=1:row
    for j=1:col
        % In the Low-frequency, we use the weight computed above.
        w1 = saliency1(i,j)/(saliency1(i,j)+ saliency2(i,j));
        w2 = saliency2(i,j)/(saliency1(i,j)+ saliency2(i,j));
        %A(i,j)=w1*A1(i,j)+w2*A2(i,j);
        A(i,j)=(A1(i,j)+ A2(i,j))/2;
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

%fusion the second rank coefficient 
for i=1:row2
    for j=1:col2
%       A(i,j)=w3*A1(i,j)+w4*A2(i,j);
        w3 = saliency_coefl(i,j)/(saliency_coefl(i,j)+ saliency_coefr(i,j));
        w4 = saliency_coefr(i,j)/(saliency_coefl(i,j)+ saliency_coefr(i,j));
        A(i,j)=w3*A1(i,j)+w4*A2(i,j);
    end
end
        
%% Rebuild the image
img=idwt2(A,H,V,D,'db1');
end

