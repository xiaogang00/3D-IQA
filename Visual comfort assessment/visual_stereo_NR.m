function feature = visual_stereo3_NR(iml, imr)
% [stereo_saliency, ~, count_1]= visualComfort_feature(iml, imr);
% [d, ~, ~, ~] = stereo(imr,iml,20);
% [m, n] = size(stereo_saliency);

[feature1, temp_d, temp_saliency, mean_value] = compute_disparity(iml, imr);
 
%feature2 = compute_edge(temp_d, temp_saliency);

feature3 = frequency_domain(iml, temp_saliency, mean_value);

if (length(size(iml)) == 3)
    iml = rgb2gray(iml);
end

if (length(size(imr)) == 3)
    imr = rgb2gray(imr);
end

temp_iml = iml;
temp_imr = imr;

featurel3 = divine_feature_extract(iml);
featurer3 = divine_feature_extract(imr);
saliency1 = saliency_SR(iml);
saliency2 = saliency_SR(imr);
sum1=sum(saliency1(:));
sum2=sum(saliency2(:));
w1 = sum1/(sum1+sum2);
w2 = sum2/(sum1+sum2);
feature7 = featurel3 * w1 + featurer3 * w2;
[~,n] = size(feature7);
max_feature = max(feature7);
min_feature = min(feature7);
for i = 1:n
    feature7(i) = (feature7(i) - min_feature + 0.01)/ (max_feature - min_feature);
end


scale = 2;
featurel2 = feature_extract3(temp_iml);
featurer2 = feature_extract3(temp_imr);
feature5 = [];
 for i = 1 : 3 : (scale - 1) * 3 + 1
      saliency1 = saliency_SR(temp_iml);
      saliency2 = saliency_SR(temp_imr);
      sum1=sum(saliency1(:));
      sum2=sum(saliency2(:));
      w1 = sum1/(sum1+sum2);
      w2 = sum2/(sum1+sum2);
      fusion = featurel2(i : i+2) * w1 + featurer2(i : i+2) * w2;
      feature5 = [feature5, fusion];
      temp_iml =  imresize(temp_iml,0.5);
      temp_imr =  imresize(temp_imr,0.5);
 end
  
[~,n] = size(feature5);
max_feature = max(feature5);
min_feature = min(feature5);
for i = 1:n
    feature5(i) = (feature5(i) - min_feature + 0.01)/ (max_feature - min_feature);
end

feature = [feature1, feature3, feature5, feature7];  