function score = edge1( ref,dis )
if (length(size(ref)) == 3)
    ref = rgb2gray(ref);
end
if (length(size(dis)) == 3)
    dis = rgb2gray(dis);
end
if (~ isa(ref, 'double'))
    ref = double(ref);
end
if (~ isa(dis, 'double'))
    dis = double(dis);
end

REF = ltrp(ref);
DIS = ltrp(dis);
norm = zeros(1,4);
for m=1:4
         distance = double(REF{1,m} - DIS{1,m});
         [row, col] = size(distance);
         all_dis = 0;
         for i = 1:row
             for j = 1:col
                 all_dis = all_dis + abs(distance(i,j));
             end
         end
         norm(1,m) = all_dis/ (row * col);
end

score1=mean2(norm);

[score2,qm] = GMSD(ref,dis);
%score3 = SR_SIM(ref,dis);
score4 = qilv(ref,dis,0);
%score=[score1, score2*200,  (1 - score3)*100,  (1 - score4)*200 ];
score=[score1, score2*200,  (1 - score4)*200 ];
end

