function saliencyMap = saliency_SR(im)

%% Read image from file
%im=imread('10.jpg');
inImg = im2double(im);
%%inImg = imresize(inImg, 64/size(inImg, 2));

%% Spectral Residual
myFFT = fft2(inImg);
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
saliencyMap = abs(ifft2(exp(mySpectralResidual + i*myPhase))).^2;

%% After Effect
saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [10, 10], 2.5)));

%% threshold excute
a=3*mean(saliencyMap(:));
saliencymap=im2bw(saliencyMap,a); 

%% plot
% subplot(131)
% imshow(im);
% title('The origin figure')
% subplot(132)
% imshow(saliencyMap);
% title('Saliency Map')
% subplot(133)
% imshow(saliencymap);
% title('Saliency Map')
