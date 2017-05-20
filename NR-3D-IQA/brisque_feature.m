function feat = brisque_feature(imdist,scalenum)
%This function compute the global features in the Spatial Domain
%we adopt a generalized Gaussian distribution (GGD) to capture 
%the spectrum of distorted imagestatistics. 
%Input:
%imdist ¡ªThe image need to extract features
%scalename¡ªThe number of multi-scalse
%Output:
%The features extracted 

window = fspecial('gaussian',7,7/6);
window = window/sum(sum(window));

feat = [];
for itr_scale = 1:scalenum

mu            = filter2(window, imdist, 'same');
mu_sq         = mu.*mu;
sigma         = sqrt(abs(filter2(window, imdist.*imdist, 'same') - mu_sq));
structdis     = (imdist-mu)./(sigma+1);


[alpha overallstd]       = estimateggdparam(structdis(:));
feat                     = [feat alpha overallstd^2]; 

imdist                   = imresize(imdist,0.5);

end