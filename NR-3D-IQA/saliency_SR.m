function saliencyMap = saliency_SR(im)
%this function is used to calculate the visual saliency map for the given
%image using the spectral residue method proposed by Xiaodi Hou and Liqing
%Zhang. For more details about this method, you can refer to the paper:
%Saliency detection: a spectral residual approach.
%Inputs:
%   im = the image to extract the saliency map
%
% Outputs:
%   saliencyMap = the saliency map of im

%% Read image from file
inImg = im2double(im);

%% Spectral Residual
myFFT = fft2(inImg);
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
saliencyMap = abs(ifft2(exp(mySpectralResidual + 1i *myPhase))).^2;

%% After Effect
%saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [10, 10], 2.5)));
saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [10, 10], 3.8)));
