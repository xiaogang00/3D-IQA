clc
clear
close all
load leleccum;
s = leleccum(1:3920);
l_s = length(s);

[C,L] = wavedec(s,3,'db1');
cA3 = appcoef(C,L,'db1',3);
cD3 = detcoef(C,L,3);
cD2 = detcoef(C,L,2);
cD1 = detcoef(C,L,1); % same as [cD1,cD2,cD3]=detcoef(C,L,[1,2,3])

%%
subplot(511);plot(s);title('s')
subplot(512);plot(cA3);title('cA3')
subplot(513);plot(cD3);title('cD3')
subplot(514);plot(cD2);title('cD2')
subplot(515);plot(cD1);title('cD1')
%%
close all
A3 = wrcoef('a',C,L,'db1',3);
%To reconstruct the details at levels 1, 2, and 3, from C
D1 = wrcoef('d',C,L,'db1',1);
D2 = wrcoef('d',C,L,'db1',2);
D3 = wrcoef('d',C,L,'db1',3);
subplot(221);plot(A3);title('Approximation A3')
subplot(222);plot(D1);title('Detail D1');
subplot(223);plot(D2);title('Detail D2');
subplot(224);plot(D3);title('Detail D3');

A0 = waverec(C,L,'db1');
err = max(abs(s-A0))
%%
%successive approximations become less and less noisy as more and more 
%high-frequency information is filtered out of the signal.
%The level 3 approximation, A3, is quite clean as a comparison between it
%and the original signal.
close all
subplot(211);plot(s);title('Original');axis off
subplot(212);plot(A3);title('Level 3 Approximation');axis off
set(gcf,'color','w')
%in discarding all the high-frequency information, we've also lost many of
%the original signal's sharpest features.
%%
%Optimal de-noising requires a more subtle approach called thresholding.
%This involves discarding only the portion of the details that exceeds a certain limit.
%%
%To denoise the signal, use the ddencmp command to calculate the default
%parameters and the wdencmp command to perform the actual de-noising
close all
[thr,sorh,keepapp] = ddencmp('den','wv',s);
clean = wdencmp('gbl',C,L,'db1',3,thr,sorh,keepapp);
subplot(211);plot(s(2000:3920));title('Original')
subplot(212);plot(clean(2000:3920));title('De-noised')
