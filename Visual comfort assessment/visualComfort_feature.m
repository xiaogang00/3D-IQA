function [stereo_saliency, count_0, count_1]= visualComfort_feature(iml, imr)

%[d, ~, ~, ~] = stereo(imr,iml,20);

[d, ~] = stereo2(imr,iml, 20);

%��������ȡ���ӵ�ͼ�� IR(x,y)���Ӿ�����ͼ
saliency = myGBVS(imr);

%imshow(saliencyl);
%������������һ����һ�������ã�ʹ����ȡ���Ӳ�ͼ��������ͼ��Ԫ�ش���ͬһ������
ms = max(max(saliency));
saliency = saliency./ms;
% for i = 1:m
%     for j = 1:n
%         saliencyl(i,j)=saliencyl(i,j)/ms;
%     end
% end

%���������ͼ���Ӳ�ͼ���õ�������������ͼ
%stereo_saliency = saliencyl * 0.5 + d * 0.5;
stereo_saliency = saliency.*d;
% figure(1);
% imshow(uint8(d));
% figure(2);
% imshow(saliency);
% figure(3);
% imshow(stereo_saliency);

[m, n] = size(stereo_saliency);
%������ͳ��һ��������VIR��Ĥͼ��1��Ԫ�ظ�����0��Ԫ�ظ�ʽ
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



