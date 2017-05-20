function feature = stereo_NR(iml, imr)
if (length(size(iml)) == 3)
    iml = rgb2gray(iml);
end

if (length(size(imr)) == 3)
    imr = rgb2gray(imr);
end

  scale1 = 3;
  scale2 = 2;
  feature1 = feature_extract(iml, scale1);
  iml = double(iml);
  feature1l = brisque_feature(iml,scale2);
  %feature_l = [ feature1, feature1l];
  
  
  feature2 = feature_extract(imr, scale1);
  imr = double(imr);
  feature1r = brisque_feature(imr,scale2);

  %feature_r = [feature2, feature1r];
  feature = [];
  temp1 = iml;
  temp2 = imr;
  for i = 1 : 4 : (scale1-1) * 4 + 1
      saliency1 = saliency_SR(temp1);
      saliency2 = saliency_SR(temp2);
      sum1=sum(saliency1(:));
      sum2=sum(saliency2(:));
      w1 = sum1/(sum1+sum2);
      w2 = sum2/(sum1+sum2);
      fusion = feature1(i : i+3) * w1 + feature2(i : i+3) * w2;
      feature = [feature, fusion];
      temp1 =  imresize(temp1,0.5);
      temp2 =  imresize(temp2,0.5);
  end
  
  for i = 1 : 2 : (scale2 - 1) * 2 + 1
      saliency1 = saliency_SR(iml);
      saliency2 = saliency_SR(imr);
      sum1=sum(saliency1(:));
      sum2=sum(saliency2(:));
      w1 = sum1/(sum1+sum2);
      w2 = sum2/(sum1+sum2);
      fusion = feature1l(i : i+1) * w1 + feature1r(i : i+1) * w2;
      feature = [feature, fusion];
      iml =  imresize(iml,0.5);
      imr =  imresize(imr,0.5);
  end
  
  max_disp = 25;
  [fdsp dmap_ref confidence diff] = mj_stereo_SSIM(iml,imr, max_disp);
  Mean = mean(mean(dmap_ref));
  Var = var(dmap_ref(:));
  temp1 = (dmap_ref - Mean).^3;
  temp2 = (dmap_ref - Mean).^2;
  temp3 = (dmap_ref - Mean).^4;
  E_temp1 = mean(mean(temp1));
  E_temp2 = mean(mean(temp2));
  E_temp3 = mean(mean(temp3));
  skew = E_temp1 / ((E_temp2)^(3.0/2));
  kurt = E_temp3 /((E_temp2)^2);
  Median = median(dmap_ref(:));
  feature = [feature, skew, kurt];
  
  
  Max = max(feature(1: scale1*4));Min = min(feature(1: scale1*4));
  feature(1: scale1*4) = (feature(1: scale1*4) - Min + 0.01) ./(Max-Min);
  
  Max = max(feature(scale1*4 + 1: scale1*4 + scale2*2));
  Min = min(feature(scale1*4 + 1: scale1*4 + scale2*2));
  feature(scale1*4 + 1: scale1*4 + scale2*2) = (feature(scale1*4 + 1: scale1*4 + scale2*2)...
     - Min + 0.01) ./(Max-Min);
 
  Max = max(feature(scale1*4 + scale2*2 + 1: scale1*4 + scale2*2 + 2));
  Min = min(feature(scale1*4 + scale2*2 + 1: scale1*4 + scale2*2 + 2));
  feature(scale1*4 + scale2*2 + 1: scale1*4 + scale2*2 + 2) = ...
      (feature(scale1*4 + scale2*2 + 1: scale1*4 + scale2*2 + 2) - Min + 0.01) ./(Max - Min);
  
end
  