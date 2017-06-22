function feature = frequency_domain(iml, stereo_saliency, mean_number)
if (length(size(iml)) == 3)
    iml = rgb2gray(iml);
end

[~,H,V,D]=dwt2(iml,'db1');
[m, n] = size(H);
stereo_saliency = imresize(stereo_saliency, 0.5);
stereo_saliency = im2bw(stereo_saliency);
SF = zeros(m, n);

for i = 1:m
    for j = 1:n
        SF(i,j) = sqrt(H(i,j)^2 + V(i,j)^2 + D(i,j)^2);
    end
end

temp1 = 0;
count = 0;
for i = 1:m
    for j =1:n
        if stereo_saliency(i,j) == 1
        temp1 = temp1 + SF(i,j);
        count = count + 1;
        end
    end
end

mean_value = temp1 / count;

temp2 = 0;
temp3 = 0;
temp4 = 0;
for i = 1:m
    for j =1:n
        if stereo_saliency(i,j) == 1
        temp2 = temp2 + (SF(i,j) - mean_value)^2;
        temp3 = temp3 + (SF(i,j) - mean_value)^3;
        temp4 = temp4 + (SF(i,j) - mean_value)^4;
        end
    end
end
E_temp2 = temp2 / count;  
E_temp3 = temp3 / count;
E_temp4 = temp4 / count;
skew = E_temp3 / ((E_temp2)^(3.0/2));
kurt = E_temp4 /((E_temp2)^2);

%sigma_value = temp1 / count;
lambda = mean_value / mean_number;
scope = max(max(SF)) - min(min(SF));

feature = [mean_value, skew, kurt, scope, lambda];
[~, n] = size(feature);
max_feature = max(feature);
min_feature = min(feature);
for i = 1:n
    feature(i) = (feature(i) - min_feature + 0.01) / (max_feature-min_feature);
end


        