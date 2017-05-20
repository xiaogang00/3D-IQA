function f = feature_extract( imdist ,scale)
%This function compute the local features using spatial entropy values
%as well as spectral entropy values
%Input:
%imdist ¡ªThe image need to extract features
%scale¡ªThe number of multi-scalse
%Output:
%The features extracted 

    f=[];
    % The method of pooling used is percentile pooling
    % 60% of the central elements are extracted
    weight=[0.2 0.8];

    for i=1:scale
        im=imdist;
        fun0=@(x)secal(x);
        emat=blkproc(im,[8 8] ,fun0); 

        sort_t = sort(emat(:),'ascend');
        len = length(sort_t);
        t=sort_t(ceil(len*weight(1)):ceil(len*weight(2)));
        mu= mean(t);
        ske=skewness(sort_t);
        
        f1=[ mu  ske];

        im=imdist;
        fun1=@(x)fecal(x);
        im=double(im);
        femat=blkproc(im,[8 8],fun1);

        sort_t = sort(femat(:),'ascend');
        len = length(sort_t);
        t=sort_t(ceil(len*weight(1)):ceil(len*weight(2)));
        mu= mean(t);
        ske=skewness(sort_t);
   
        f2=[ mu  ske];

        f=[f f1 f2] ;
        imdist = imresize(imdist,0.5,'bicubic');
    end
end
