clear all;

imgRoot='./input/'; %% test image dir
outdir='./output/'; %% output saliency map saving dir
supdir='./superpixels/'; %% superpixels files saving dir
mkdir(supdir);
mkdir(outdir);
imnames=dir([imgRoot '*' 'jpg']);
addpath(genpath('./others/'));
addpath(genpath('./ColorFeatures/'));

for im_count=1:length(imnames)
  
    im_count
    spnumber=250; %% superpixels number
    imname=[imgRoot imnames(im_count).name]; 
    input_im=imread(imname); 
    outname=[imgRoot imnames(im_count).name(1:end-4) '.bmp'];
    imwrite(input_im,outname);
    input_im=im2double(input_im);
    [m,n,z] = size(input_im);
    
%% generate superpixels

    comm=['SLICSuperpixelSegmentation' ' ' outname ' ' int2str(20) ' ' int2str(spnumber) ' ' supdir];
    system(comm);    
    spname=[supdir imnames(im_count).name(1:end-4)  '.dat'];
    superpixels=ReadDAT([m,n],spname);
    spnum=max(max(superpixels)); 
    
%% initial saliency map construction
 
    
    I_rgb = input_im;
    labels = superpixels;
    

    I_gray = rgb2gray(I_rgb);
  
    finalimage = 0;
    max_label = max(max(labels));


    kval = round(max_label*0.8);

    Groups3 = zeros(max_label,3);

    for i=1:max_label
        Groups3(i,2) = Groups3(i,2) / Groups3(i,1) ; 
        Groups3(i,3) = Groups3(i,3) / Groups3(i,1) ;
    end

    matrixret = I_gray;

    [rows,cols]=size(I_rgb(:,:,1));

    LAB = RGB2Lab(I_rgb);
    s1 = LAB(:,:,1);
    s2 = LAB(:,:,2);
    s3 = LAB(:,:,3);
    
    lcomp = (s1 - min(s1(:)))/(max(s1(:))-min(s1(:)));
    acomp = (s2 - min(s2(:)))/(max(s2(:))-min(s2(:)));
    bcomp = (s3 - min(s3(:)))/(max(s3(:))-min(s3(:)));
    
    compactMapL = calculatecompactness(s1);
    compactMapa = calculatecompactness(s2);
    compactMapb = calculatecompactness(s3);
    
    compactMap = sqrt(compactMapL.^2 + compactMapa.^2 + compactMapb.^2);
    maxB = max(compactMap(:));
    minB = min(compactMap(:));
    compactMap = (compactMap - minB) / (maxB - minB);

    
    imagecopy = matrixret;
    
    if min(min(matrixret)) < 0
        matrixret = matrixret - min(min(matrixret));
    end


    Groups = zeros(max_label,7);
    [rows_lab,columns_lab] = size(labels);

    for i=1:rows_lab
        for j=1:columns_lab
            Groups(labels(i,j),1) = Groups(labels(i,j),1) + 1; %count
            Groups(labels(i,j),2) = Groups(labels(i,j),2) + i; %x coordinates
            Groups(labels(i,j),3) = Groups(labels(i,j),3) + j; %y coordinates
            Groups(labels(i,j),4) = Groups(labels(i,j),4) + lcomp(i,j); %intensity
            Groups(labels(i,j),5) = Groups(labels(i,j),5) + compactMap(i,j); %compactness
            Groups(labels(i,j),6) = Groups(labels(i,j),6) + acomp(i,j);
            Groups(labels(i,j),7) = Groups(labels(i,j),7) + bcomp(i,j);
           
        end
    end

    for i=1:max_label
        Groups(i,2) = Groups(i,2) / Groups(i,1) ; % x mean
        Groups(i,3) = Groups(i,3) / Groups(i,1) ; % y mean 
        Groups(i,4) = Groups(i,4) / Groups(i,1) ; % intensity mean
        Groups(i,5) = Groups(i,5) / Groups(i,1) ;
        Groups(i,6) = Groups(i,6) / Groups(i,1) ;
        Groups(i,7) = Groups(i,7) / Groups(i,1) ;

    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Constructing gbvs graph

    count = max_label;
   
    Df=zeros(count,count);
    Com=zeros(count,count);
    sigma = columns_lab/7;

    maxDf = 0;
    for i=1:count
        for j=1:count
              if i==j
                  Df(i,j)=0;
              else
                  
                  Ldiff = abs(Groups(i,4)-Groups(j,4));
                  adiff = abs(Groups(i,6)-Groups(j,6));
                  bdiff = abs(Groups(i,7)-Groups(j,7));
                  
              Df(i,j) = sqrt(Ldiff^2 + adiff^2 + bdiff^2);
              Com(i,j) = 1 + abs(Groups(i,5)-Groups(j,5))/2;

              end
        end
    end

   
    F=zeros(count,count);
    F1 = zeros(count);
   
    [rowsn,colsn] =  size(matrixret);
    
    for i=1:count
        for j=1:count

            if i~=j

            ed = exp((-1*sqrt((Groups(i,2)-Groups(j,2))^2 + (Groups(i,3)-Groups(j,3))^2))/(2*sigma^2)) ;

             productdist=(Df(i,j)*ed*Com(i,j));

             F(i,j) = productdist;
            else
             F(i,j) = 0;
            end

        end
        maxnew=sum(F(i,:));
        F1(i) = max(F(i,:));
        F(i,:)=F(i,:)/maxnew;
    end

    countfresh=0;

    [rows1,cols]=size(F);

    pibar=limitdist(F');

    
    pibar(pibar<0)=0;

    [e,w]=max(pibar);
    [emin,wmin]=min(pibar);

    gamma = 2;

    for j=1:rows_lab
        for k=1:columns_lab
            imagecopy(j,k)=((pibar(labels(j,k))-emin)/(e - emin))^gamma;
  
        end
    end

    imagecopy = 1 - imagecopy;

         asal = imagecopy;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Constructing graph from saliency map

    Groups1 = zeros(max_label,5);
    imaftsaliency = imagecopy;

    
    for i=1:rows_lab
        for j=1:columns_lab
            Groups1(labels(i,j),1) = Groups1(labels(i,j),1) + 1; %count
            Groups1(labels(i,j),2) = Groups1(labels(i,j),2) + i; %x coordinates
            Groups1(labels(i,j),3) = Groups1(labels(i,j),3) + j; %y coordinates
            Groups1(labels(i,j),4) = Groups1(labels(i,j),4) + imaftsaliency(i,j); %intensity
        end
    end

    for i=1:max_label
        Groups1(i,2) = Groups1(i,2) / Groups1(i,1) ; % x mean
        Groups1(i,3) = Groups1(i,3) / Groups1(i,1) ; % y mean 
        Groups1(i,4) = Groups1(i,4) / Groups1(i,1) ; % intensity mean

    end


    count = max_label;
    countnew=0;
    Df1=zeros(count,count);
    Com1=zeros(count,count);
    maxDf1 = 0;
    for i=1:count
        for j=1:count
              if i==j
                  Df1(i,j)=0;
              else
              Df1(i,j) = abs(Groups1(i,4)-Groups1(j,4));

              end
        end
    end


    countr=0;counthero=0;countnew2=0;counted=0;
    Fd=zeros(count,count);
    F1d = zeros(count);
    ef = 1;

    for i=1:count
        for j=1:count
            if i~=j
                
               ed = 1 - (sqrt((Groups1(i,2)-Groups1(j,2))^2 + (Groups1(i,3)-Groups1(j,3))^2))/(sqrt(rowsn^2 + colsn^2));
    
                  productdist=(Df1(i,j))*ed*Com(i,j);

             Fd(i,j) = productdist;
            else
             Fd(i,j) = 0;
            end

        end
    
        F1d(i) = max(Fd(i,:));
    end


    maxval = max(max(Fd));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % entropy based edge thresholding 
    
    maxentropy = 0;
    maxthresh = 0;

    if maxval ~= 0
        
        for i = 0.1*maxval:0.05*maxval:0.95*maxval

            thresh = i;

            ratiorej = sum(Fd(Fd > thresh))/sum(sum(Fd));

            ratiokept = 1 - ratiorej;
            if ratiorej ~= 0 || ratiokept ~= 0
                entropy = -ratiorej * log(ratiorej) - ratiokept*log(ratiokept);
            end

            if entropy > maxentropy

                maxentropy = entropy;
                maxthresh  = thresh;
            end
        end
   
    end

    edgec = 0;
    for i=1:count
        for j=1:count
            if( Fd(i,j) < maxthresh)
                Fd(i,j) = 0;
            else
                Fd(i,j) = 1;
                edgec = edgec + 1;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % k-dense subgraph calculation
   

    [d1,degreenet1] = modproc1(Fd,count,edgec,kval);
    den1 = calcdensity(d1,Fd);

    [d2,degreenet2] = modproc2(Fd,count,kval);
    den2 = calcdensity(d2,Fd);
    
    [d3,degreenet3] = modproc3(Fd,count,kval);
    den3 = calcdensity(d3,Fd);
    
    maxden = 0;
        if den1 >= maxden
            maxden = den1;
            vertexsetn = d1;
            degreenet = degreenet1;
        end
        
        if den2 >= maxden
            maxden = den2;
            vertexsetn = d2;
            degreenet = degreenet2;

        end
        
        if den3 >= maxden
            maxden = den3;
            vertexsetn = d3;
            degreenet = degreenet3;

        end
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % computing final saliency map
    gamma = 4;
    
 
    for j=1:rows_lab
        for k=1:columns_lab
            [yesno,pos] = findinarrray(vertexsetn,labels(j,k));
            if yesno == 1
                  if degreenet(pos) > mean(degreenet)
                    imagecopy(j,k) = ((degreenet(pos))/(max(degreenet)))^(1/gamma);
                  else
                    imagecopy(j,k) = ((degreenet(pos))/(max(degreenet)))^(gamma);  
                  end

            else
                  imagecopy(j,k)=0;
            end
        end
    end


    a = imagecopy;
    maxB = max(a(:));
    minB = min(a(:));
    a = (a - minB) / (maxB - minB);

    finalimage2 = a;
    maxB = max(finalimage2(:));
    minB = min(finalimage2(:));
    finalimage2 = (finalimage2 - minB) / (maxB - minB);

    finalimagenorm = finalimage2 .* (asal.^2) ;

    maxB = max(finalimagenorm(:));
    minB = min(finalimagenorm(:));
    finalimagenorm = (finalimagenorm - minB) / (maxB - minB);


    outname=[outdir imnames(im_count).name(1:end-4) '_dense' '.png'];   
    imwrite(finalimagenorm,outname);


end
