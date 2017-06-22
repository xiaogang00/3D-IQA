function  out = myGBVS( img )
%img=imread(scr);
r=img(:,:,1);
g=img(:,:,2);
b=img(:,:,3);

r=im2double(r);
g=im2double(g);
b=im2double(b);

I=(r+g+b)./3;
R=r-(g+b)./2;
G=g-(r+b)./2;
B=b-(r+g)./2;
Y=(r+g)./2-(abs(r-g))./2-b;
O=get4orient(I);


%compute saliency
Isal=getgbvsmap(I);
Rsal=getgbvsmap(R);
Gsal=getgbvsmap(G);
Bsal=getgbvsmap(B);
Ysal=getgbvsmap(Y);
Osal0=getgbvsmap(O{1,1});
Osal45=getgbvsmap(O{1,2});
Osal90=getgbvsmap(O{1,3});
Osal135=getgbvsmap(O{1,4});

%resize
Isalre=imresize(Isal,size(r),'bicubic');
Rsalre=imresize(Rsal,size(r),'bicubic');
Gsalre=imresize(Gsal,size(r),'bicubic');
Bsalre=imresize(Bsal,size(r),'bicubic');
Ysalre=imresize(Ysal,size(r),'bicubic');
Osal0re=imresize(Osal0,size(r),'bicubic');
Osal45re=imresize(Osal45,size(r),'bicubic');
Osal90re=imresize(Osal90,size(r),'bicubic');
Osal135re=imresize(Osal135,size(r),'bicubic');

%combination
S=(Isalre+Rsalre+Gsalre+Bsalre+Ysalre+Osal0re+Osal45re+Osal90re+Osal135re)./9;
S=mat2gray(S);


T=graythresh(S);
Sbi=im2bw(S,T);
Sbi=bwmorph(Sbi,'spur');
Sbi=bwmorph(Sbi,'clean');
S1=Sbi.*(im2double((img(:,:,1))));
S2=Sbi.*(im2double((img(:,:,2))));
S3=Sbi.*(im2double((img(:,:,3))));
S0=cat(3,S1,S2,S3);
out = S;

% figure;
% subplot(221);imshow(img);title('origin');
% subplot(222);imshow(S);title('myGBVS');
% subplot(223);imshow(Sbi);
% subplot(224);imshow(S0);
end

