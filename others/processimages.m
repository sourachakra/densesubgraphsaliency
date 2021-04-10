clear all;
imgRoot='./our input images/';% test image path
saldir='./our output images/';% the output path of the saliency map
mkdir(saldir);
imnames=dir([imgRoot '*' 'jpg']);

for ii=1:length(imnames)   
    disp(ii);
    imname=[imgRoot imnames(ii).name];
    
MinimumRegionArea=1500;
I=imread(imname);
imshow(imname);
[fimg labels modes regsize] = edison_wrapper(uint8(I),@RGB2Luv,'MinimumRegionArea',MinimumRegionArea);
I_rgb = Luv2RGB(fimg);
I_rgb = double(I_rgb);

imwrite(I_rgb,'I.jpg');


I_gray = rgb2gray(I_rgb);
matrixret = I_gray;
imagecopy = I_gray;
finalimage = I_gray;
finalimage = double(finalimage);
finalimage = 0;
labels = labels + 1;
max_label = max(max(labels));
max_label
% kval = input('Enter value of k:');
kval = (max_label*0.8);
hsv_image = rgb2hsv(I_rgb);
[rows_lab,columns_lab] = size(labels);

hmap = hsv_image(:,:,1);
smap = hsv_image(:,:,2);
hwarm = hmap;
% val = 1;
% 
% for i = 1:rows_lab
%     for j = 1:columns_lab
%         if hmap(i,j) > val/6 && hmap(i,j) < (5*val)/6
%             hwarm = 0;
%         end
%     end
% end

hl = min(min(hmap));
hu = max(max(hmap));
sl = min(min(smap));
su = max(max(smap));

 min(min(hmap))
 max(max(hmap))
hl
hu
sl
su

% fde = input('adad');
Groups3 = zeros(max_label,3);


for i=1:rows_lab
    for j=1:columns_lab
        Groups3(labels(i,j),1) = Groups3(labels(i,j),1) + 1; %count
        Groups3(labels(i,j),2) = Groups3(labels(i,j),2) + hmap(i,j); %intensity
        Groups3(labels(i,j),3) = Groups3(labels(i,j),3) + smap(i,j); %intensity
    end
end

for i=1:max_label
    
    Groups3(i,2) = Groups3(i,2) / Groups3(i,1) ; 
    Groups3(i,3) = Groups3(i,3) / Groups3(i,1) ;
%     fprintf('i = %d,max_label = %d,count %d, x: %f, y: %f, intenstiy: %f\n',i,max_label,Groups(i,1),Groups(i,2),Groups(i,3),Groups(i,4));
end

for h = 1:3
    

val = h ;
h
matrixret = chooseoption1(I_rgb,val);
% matrixret = matrixret .* (max(max(matrixret))- mean(mean(matrixret)))*(max(max(matrixret))- mean(mean(matrixret)));

figure(3);imshow(matrixret);
imagecopy = matrixret;
% fde = input('adad');

Groups = zeros(max_label,4);
[rows_lab,columns_lab] = size(labels);

for i=1:rows_lab
    for j=1:columns_lab
        Groups(labels(i,j),1) = Groups(labels(i,j),1) + 1; %count
        Groups(labels(i,j),2) = Groups(labels(i,j),2) + i; %x coordinates
        Groups(labels(i,j),3) = Groups(labels(i,j),3) + j; %y coordinates
        Groups(labels(i,j),4) = Groups(labels(i,j),4) + matrixret(i,j); %intensity
    end
end

for i=1:max_label
    Groups(i,2) = Groups(i,2) / Groups(i,1) ; % x mean
    Groups(i,3) = Groups(i,3) / Groups(i,1) ; % y mean 
    Groups(i,4) = Groups(i,4) / Groups(i,1) ; % intensity mean
%     fprintf('i = %d,max_label = %d,count %d, x: %f, y: %f, intenstiy: %f\n',i,max_label,Groups(i,1),Groups(i,2),Groups(i,3),Groups(i,4));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

count = max_label;
countnew=0;
Df=zeros(count,count);
for i=1:count
    for j=1:count
          if i==j
              Df(i,j)=0;
          else
          Df(i,j) = abs(Groups(i,4)-Groups(j,4));
          end
    end
end

countr=0;counthero=0;countnew2=0;counted=0;
F=zeros(count,count);
F1 = zeros(count);

for i=1:count
    for j=1:count
        if i~=j
           ed = 1/(sqrt((Groups(i,2)-Groups(j,2))^2 + (Groups(i,3)-Groups(j,3))^2));
        if ed <0.000001
            counted=counted+1;
        end
         productdist=(Df(i,j));
         
        if(productdist == 0)
            counthero=counthero+1;
        end
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
% fprintf('\n%d rows,%d cols\n',rows1,cols);

pibar=limitdist(F');

% fprintf('\nsumv\n');
pibar(pibar<0)=0;
% pibar
[e,w]=max(pibar);
pibar(w) = mean(pibar);
% pibar
% input('ddd');


for j=1:rows_lab
    for k=1:columns_lab
        imagecopy(j,k)=((pibar(labels(j,k)))/e);
    end
end

imagecopy = 1 - imagecopy;
 if h==1
     imwrite(imagecopy,'saliency1.jpg');
     asal1 = imagecopy;
 end
 if h==2
     imwrite(imagecopy,'saliency2.jpg');
     asal2 = imagecopy;
 end
 if h==3
     imwrite(imagecopy,'saliency3.jpg');
     asal3 = imagecopy;
 end
figure(4);imshow(imagecopy);

%*****************************
%*****************************

%generating graph from saliency map

Groups1 = zeros(max_label,4);
imaftsaliency = matrixret;

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
%     fprintf('i = %d,max_label = %d,count %d, x: %f, y: %f, intenstiy: %f\n',i,max_label,Groups1(i,1),Groups1(i,2),Groups1(i,3),Groups1(i,4));
end


count = max_label;
countnew=0;
Df1=zeros(count,count);
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
           ed = exp(-0.5*((Groups1(i,2)-Groups1(j,2))^2 + (Groups1(i,3)-Groups1(j,3))^2));
        if ed <0.000001
            counted=counted+1;
        end
        mf = 1 + ef*((hu - min(min(Groups3(i,2),Groups3(j,2)),hu))/(hu-hl))*((max(Groups3(i,3),Groups3(j,3))-sl)/(su-sl));
%         productdist=(Df1(i,j))*ed*mf;
            productdist=(Df1(i,j))*mf;
         
        if(productdist == 0)
            counthero=counthero+1;
        end
         Fd(i,j) = productdist;
        else
         Fd(i,j) = 0;
        end
       
    end
%     maxnew=sum(Fd(i,:));
%     Fd(i,:)=Fd(i,:)/maxnew;
    F1d(i) = max(Fd(i,:));
end


maxval = max(max(Fd));
% fprintf('maxval = %f',maxval);
maxentropy = 0;
maxthresh = 0;

if maxval ~= 0
    
for i = 0.1*maxval:0.1*maxval:0.95*maxval
thresh = i;

ratiorej = sum(Fd(Fd > thresh))/sum(sum(Fd));
% ratiorej
ratiokept = 1 - ratiorej;
if ratiorej ~= 0 || ratiokept ~= 0
    entropy = -ratiorej * log(ratiorej) - ratiokept*log(ratiokept);
end
% entropy
if entropy > maxentropy
    
    maxentropy = entropy;
    maxthresh  = thresh;
end
end
% fprintf('maxthresh = %f,ratrej = %f,ratkept = %f,entropy=%f\n',maxthresh,ratiorej,ratiokept,maxentropy);
% b=input('hhgghh');
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% k dense subgraph calculation
% edgec

[d1,degreenet1] = modproc1(Fd,count,edgec,kval);
den1 = calcdensity(d1,Fd);
% den1
% d1
[d2,degreenet2] = modproc2(Fd,count,kval);
den2 = calcdensity(d2,Fd);
% den2
% d2
[d3,degreenet3] = modproc3(Fd,count,kval);
den3 = calcdensity(d3,Fd);
% den3
% d3
maxden = 0;
    if den1 >= maxden
        maxden = den1;
        vertexsetn = d1;
        fprintf('win 1\n');
        length(vertexsetn)
        degreenet = degreenet1;

    end
    if den2 >= maxden
        maxden = den2;
        vertexsetn = d2;
        fprintf('win 2\n');
        degreenet = degreenet2;
%         vertexsetn
    end
    if den3 >= maxden
        maxden = den3;
        vertexsetn = d3;
        fprintf('win 3\n');
        degreenet = degreenet3;
%         vertexsetn
    end
    
fprintf('fgffgfg\n');
numel(vertexsetn)
for j=1:rows_lab
    for k=1:columns_lab
        [yesno,pos] = findinarrray(vertexsetn,labels(j,k));
        if yesno == 1
           imagecopy(j,k)=degreenet(pos)/max(degreenet);
        else
        imagecopy(j,k)=0;
        end
    end
end


imwrite(imagecopy,'splash1.jpg');

if h== 1
    imwrite(imagecopy,'pic1.jpg');
    finalimage = finalimage + 0.667*imagecopy;
    imwrite(matrixret,'pic4.jpg');
    a1 = imagecopy;
end
if h== 2
    imwrite(imagecopy,'pic2.jpg');
    finalimage = finalimage + 0.167*imagecopy;
    imwrite(matrixret,'pic5.jpg');
    AChannel = matrixret;
    a2 = imagecopy;
end
if h== 3
    imwrite(imagecopy,'pic3.jpg');
    finalimage = finalimage + 0.167*imagecopy;
    imwrite(matrixret,'pic6.jpg');
    BChannel = matrixret;
    a3 = imagecopy;
end
    
    
clearvars -except h kval max_label labels finalimage imagecopy matrixret I_gray I_rgb rows_lab columns_lab AChannel BChannel a1 a2 a3 asal1 asal2 asal3 hl hu sl su Groups3 imgRoot saldir imnames ii;
end

finalimage1 = sqrt(a1.^2 + a2.^2 + a3.^2);
salimage = sqrt(asal1.^2 + asal2.^2 + asal3.^2);

imwrite(salimage,'salimage.jpg');

imwrite(finalimage1,'finalim.jpg');


% finalimage2 = max(finalimage1,salimage);
finalimage2 = finalimage1+salimage;
maxB = max(finalimage2(:));
minB = min(finalimage2(:));
finalimage2 = (finalimage2 - minB) / (maxB - minB);



finalimagenorm = finalimage2;


max_label
imwrite(finalimagenorm,'finalimagenorm.jpg');
outname=[saldir imnames(ii).name(1:end-4) '' '.jpg'];   
imwrite(finalimagenorm,outname);

end