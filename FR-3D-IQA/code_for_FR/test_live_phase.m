function  test_live_phase(algo_name)

close all;
clc; clear;

try 
    if length(algo_name)>2 && strcmp(algo_name(end-2:end),'_NR')
        expression = strcat(algo_name,'(dis_img)');
    else
        expression = strcat(algo_name,'(ref_img,dis_img)');
    end 
    
    database_name='3d_IQA_database';
    load('../3d_IQA_database/data.mat');
    type = {'jp2k','jpeg','wn','blur','ff'};
    
    MetricScore = [];
tic
for k=1:length(type)
    if strcmp(type(k),'jp2k')
        offset= 0;
        sta = 1;
        tem = 80;
        basepath = '../3d_IQA_database/jp2k/';
        dist_label=1;
    elseif strcmp(type(k),'jpeg')
        offset= 80;
        sta = 1;
        tem = 80;
        basepath = '../3d_IQA_database/jpeg/';
        dist_label=2;
    elseif strcmp(type(k),'wn')
        offset= 80+80;
        sta = 1;
        tem = 80;
        basepath = '../3d_IQA_database/wn/';
        dist_label=3;
    elseif strcmp(type(k),'blur')
        offset= 80+80+80;
        sta = 1;
        tem = 45;
        basepath = '../3d_IQA_database/blur/';
        dist_label=4;
    elseif strcmp(type(k),'ff')
        offset= 80+80+80+45;
        sta = 1;
        tem = 80;
        basepath = '../3d_IQA_database/ff/';
        dist_label=5;
    end 
    for n = sta:tem
        index = num2str(n);
        ref_name = img_names{offset+ n};
        ref_name = ref_name(1:length(ref_name)-4);
        disl_pathname= strcat(basepath,ref_name,'_l','.bmp');
        disr_pathname= strcat(basepath,ref_name,'_r','.bmp');
        dis_l = imread(refl_pathname);
        dis_r = imread(refr_pathname);
        ref_basepath = '../3d_IQA_database/refimgs/';
        refl_pathname= strcat(ref_basepath,ref_name,'_l','.bmp');
        refr_pathname= strcat(ref_basepath,ref_name,'_r','.bmp');
        ref_l = imread(refl_pathname);
        ref_r = imread(refr_pathname);
        dis_l= rgb2gray(dis_l); dis_r= rgb2gray(dis_r);
        ref_l= rgb2gray(ref_l); ref_r= rgb2gray(ref_r);
        Score = MJ3DQA(ref_l,ref_r,dis_l,dis_r);
        MetricScore = [MetricScore,Score];
    end
end

        
        
    
    