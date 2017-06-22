function [feature1, temp_d, temp_saliency, mean_value] = compute_disparity(iml, imr)
feature1 = [];

for scale = 1:1
[stereo_saliency, ~, count_1]= visualComfort_feature(iml, imr);
[d, ~] = stereo2(imr,iml, 20);
%[d, ~, ~, ~] = stereo(imr,iml,20);
[m, n] = size(stereo_saliency);

%在这里计算VIR视差的均值
temp1 = 0;
for i = 1:m
    for j = 1:n
        if stereo_saliency(i,j) == 1
            temp1 = temp1 + d(i,j)*stereo_saliency(i,j);
        end
    end
end
mean_disparity = temp1 / count_1;

%在这里计算VIR视差的统计参数
temp2 = 0;
temp3 = 0;
temp4 = 0;
disparity = [];
for i = 1:m
    for j = 1:n
        if stereo_saliency(i,j) == 1
            disparity = [disparity, d(i,j)];
            temp2 = temp2 + (d(i,j) - mean_disparity)^2 * stereo_saliency(i,j);
            temp3 = temp3 + (d(i,j) - mean_disparity)^3 * stereo_saliency(i,j);
            temp4 = temp4 + (d(i,j) - mean_disparity)^4 * stereo_saliency(i,j);
        end
    end
end

%sigma_disparity = temp2 / count_1;
E_temp2 = temp2 / count_1;  
E_temp3 = temp3 / count_1;
E_temp4 = temp4 / count_1;
skew = E_temp3 / ((E_temp2)^(3.0/2));
kurt = E_temp4 /((E_temp2)^2);

disparity = sort(disparity);
[~, length] = size(disparity);
disparity_min = mean(disparity(1:ceil(length * 0.05)));
disparity_max = mean(disparity(ceil(length * 0.05):length));

scope = disparity_max - disparity_min;
feature1 = [feature1, mean_disparity, skew, kurt, scope];

if scale == 1
    temp_d = d;
    temp_saliency = stereo_saliency;
    mean_value = mean_disparity;
end

iml = imresize(iml, 0.5);
imr = imresize(imr, 0.5);
end

max_feature1 = max(feature1);
min_feature1 = min(feature1);
[~, n] = size(feature1);
for i = 1:n
    feature1(i) = (feature1(i) - min_feature1 + 0.01) / (max_feature1 - min_feature1);
end
