function feature = compute_edge(d, stereo_saliency)
feature = [];

%for scale = 1:1
    
[dxmap, dymap] = gradient(d);
[m, n] = size(d);
m_disparity = zeros(m, n);
theta_disparity = zeros(m, n);

dxmap = double(dxmap);
dymap = double(dymap);
for i = 1:m
    for j = 1:n
        m_disparity(i,j) = sqrt(dxmap(i,j)^2 + dymap(i,j)^2);
        theta_disparity(i,j) = atan2(dymap(i,j),dxmap(i,j));
    end
end

e_map = zeros(m,n);
for i = 2:m-1
    for j = 2:n-1
        temp = 0;
        for dx = -1:1
            for dy = -1:1
                p = [i, j];
                q = [i+dx, j+dy];
                theta_p = [sin(theta_disparity(i,j)), cos(theta_disparity(i,j))];
                theta_q = [sin(theta_disparity(i+dx,j+dy)), cos(theta_disparity(i+dx,j+dy))];
                Gs = exp(-(norm(p-q)^2)/0.8);
                Go = exp(-(norm(theta_p - theta_q)^2)/0.8);
                temp = temp + Gs * Go * m_disparity(i+dx,j+dy);
            end
        end
        e_map(i,j) = temp;
    end
end
% figure(1);
% imshow(m_disparity);
% figure(2);
% imshow(theta_disparity);

temp1 = 0;
count = 0;
for i = 1:m
    for j = 1:n
        if stereo_saliency(i,j) == 1
            temp1 = temp1 + e_map(i,j) * stereo_saliency(i,j);
            count = count + 1;
        end
    end
end

feature_temp = temp1 / count;
feature = [feature, feature_temp];

% d = imresize(d, 0.5);
% stereo_saliency = imresize(stereo_saliency, 0.5);
% stereo_saliency = im2bw(stereo_saliency);
% end

% [~,n] = size(feature);
% max_feature = max(feature);
% min_feature = min(feature);
% 
% for i = 1:n
%     feature(i) = (feature(i) - min_feature + 0.01)/ (max_feature - min_feature);
% end
                

