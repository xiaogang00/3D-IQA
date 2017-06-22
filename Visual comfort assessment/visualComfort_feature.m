function [stereo_saliency, count_0, count_1]= visualComfort_feature(iml, imr)

%[d, ~, ~, ~] = stereo(imr,iml,20);

[d, ~] = stereo2(imr,iml, 20);

%在这里提取右视点图像 IR(x,y)的视觉显著图
saliency = myGBVS(imr);

%imshow(saliencyl);
%在这里我们做一步归一化的设置，使得提取的视差图和右显著图的元素处于同一数量级
ms = max(max(saliency));
saliency = saliency./ms;
% for i = 1:m
%     for j = 1:n
%         saliencyl(i,j)=saliencyl(i,j)/ms;
%     end
% end

%结合右显著图和视差图来得到最后的立体显著图
%stereo_saliency = saliencyl * 0.5 + d * 0.5;
stereo_saliency = saliency.*d;
% figure(1);
% imshow(uint8(d));
% figure(2);
% imshow(saliency);
% figure(3);
% imshow(stereo_saliency);

[m, n] = size(stereo_saliency);
%在这里统计一下在最后的VIR掩膜图中1的元素个数和0的元素格式
count_0 = 0;
count_1 = 0;
max_number = max(max(stereo_saliency));
%thresh = graythresh(stereo_saliency);
for i = 1:m
    for j = 1:n
        if stereo_saliency(i,j) > floor(max_number*0.3)
            stereo_saliency(i,j) = 1;
            count_1 = count_1+1;
        else
            stereo_saliency(i,j) = 0;
            count_0 = count_0+1;
        end
    end
end
%imshow(stereo_saliency)
end



