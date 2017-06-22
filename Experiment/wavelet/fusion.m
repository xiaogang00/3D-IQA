function img = fusion(img_l,img_r)
%% The decomposition of image which is RGB
imgl_red  =double(img_l(:,:,1))/255;
imgl_green=double(img_l(:,:,2))/255;
imgl_blue =double(img_l(:,:,3))/255;
[row,col,height]=size(img_l);

%x2=rgb2gray(x2);
%x2=double(x2)/255; 
imgr_red   = double(img_r(:,:,1))/255;
imgr_green = double(img_r(:,:,2))/255;
imgr_blue  = double(img_r(:,:,3))/255;

%% fusion channel of RGB respectively 
img_red   = wavelet2(imgl_red,imgr_red);
img_green = wavelet2(imgl_green,imgr_green);
img_blue  = wavelet2(imgl_blue,imgr_blue);

%% Rebuild the color image 
img = zeros(row,col,3);
img(:,:,1) = img_red;
img(:,:,2) = img_green;
img(:,:,3) = img_blue;
imshow(img);
imwrite(img,'wavefusionV1.bmp');
