function [score, dmap_ref,dmap_test] = MJ3DQA(imRL,imRR,imDL,imDR,max_disp)




% Input
% imRL - ref_left view
% imRR - ref_right view
% imDL - test_left view
% imDR - test_right view
% max_disp  - max disparity value . This value may be tuned for different dataset.  

% Output
% score- Predict QA score
% dmap_ref - estimated disparity from reference pair
% dmap_test - estimated disparity from test pair

if (nargin < 4)
    score = -Inf;
    disparity_map = 0;
    return;
end
if (nargin ==4 )
    max_disp = 25;  % the dault value is set based on experiments on LIVE 3D IQA database
end


if(size(imRL,3)==3)
    imRL = rgb2gray(imRL);
    imRR = rgb2gray(imRR);
    imDL = rgb2gray(imDL);
    imDR = rgb2gray(imDR);
    
end


imsz = size(imRL);



[fdsp dmap_ref confidence diff] = mj_stereo_SSIM(imRL,imRR, max_disp);


[Ref_L_Gabor_RS,Ref_L_Gabor_Bound]=ExtractGaborResponse(imRL);
[Syn_R_Gabor_RS,Syn_R_Gabor_Bound]=ExtractGaborResponse(imRR);

[  disp_comp_rl ] = mj_computeDispCompIm( imRL,imRR,dmap_ref );

RL_en=zeros(imsz(1),imsz(2),2); %4-scales
RS_en=zeros(imsz(1),imsz(2),2); %4-scales
for mm=1:4
    RL_en(:,:,mm) = Ref_L_Gabor_RS{2+mm,1}+Ref_L_Gabor_RS{2+mm,3}+Ref_L_Gabor_RS{2+mm,5}+Ref_L_Gabor_RS{2+mm,7};
    RS_en(:,:,mm) = Syn_R_Gabor_RS{2+mm,1}+Syn_R_Gabor_RS{2+mm,3}+Syn_R_Gabor_RS{2+mm,5}+Syn_R_Gabor_RS{2+mm,7};
end

GB_L = RL_en(:,:,1) ;
GB_R = RS_en(:,:,1) ;


[ disp_comp_GBl ] = mj_computeDispCompIm( GB_L,GB_R,dmap_ref );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ M_W_R ] = mj_GenMergeWEntropy( imRL,disp_comp_rl,GB_L,disp_comp_GBl );



[fdsp dmap_test confidence diff] = mj_stereo_SSIM(imDL,imDR, max_disp);
[ disp_comp_dl] = mj_computeDispCompIm( imDL,imDR,dmap_test );


[D_L_Gabor_RS,D_L_Gabor_Bound]=ExtractGaborResponse(imDL);
[Syn_D_Gabor_RS,Syn_D_Gabor_Bound]=ExtractGaborResponse(imDR);


SL_en=zeros(imsz(1),imsz(2),2); %4-scales
SS_en=zeros(imsz(1),imsz(2),2); %4-scales
for mm=1:4
    SL_en(:,:,mm) = D_L_Gabor_RS{2+mm,1}+D_L_Gabor_RS{2+mm,3}+D_L_Gabor_RS{2+mm,5}+D_L_Gabor_RS{2+mm,7};
    SS_en(:,:,mm) = Syn_D_Gabor_RS{2+mm,1}+Syn_D_Gabor_RS{2+mm,3}+Syn_D_Gabor_RS{2+mm,5}+Syn_D_Gabor_RS{2+mm,7};
end
GBD_L = SL_en(:,:,1) ;
GBD_R = SS_en(:,:,1) ;


[ disp_comp_GBdl ] = mj_computeDispCompIm( GBD_L,GBD_R,dmap_test );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ M_W_D ] = mj_GenMergeWEntropy( imDL,disp_comp_dl,GBD_L,disp_comp_GBdl );


score = msssim(M_W_R, M_W_D);


end




