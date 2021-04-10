function compactMap = calculatecompactness(matrixret)

alpha = 15;

matrixret = ((matrixret-min(min(matrixret)))/(max(max(matrixret))-min(min(matrixret))))*255+1;
matrixret = ceil(matrixret);

[rowsn,colsn] = size(matrixret);
delta = max(rowsn,colsn)/256;

count =zeros(256);
totalx = zeros(256);
totaly = zeros(256);


for i=1:rowsn
    for j=1:colsn
        totalx(matrixret(i,j)) = totalx(matrixret(i,j))+i;
        totaly(matrixret(i,j)) = totaly(matrixret(i,j))+j;
        count(matrixret(i,j)) = count(matrixret(i,j)) + 1;
    end
end

p=1;
for i=1:max(max(matrixret))
        if count(i)~= 0
            avgx(i) = totalx(i)/count(i);
            avgy(i) = totaly(i)/count(i);
        else
             avgx(i) = 0;
             avgy(i) = 0;
             p = p+1;
        end
end

Tn = zeros(256-(p-1),3);
q = 1;
for i=1:max(max(matrixret))
        if avgx(i) == 0 && avgy(i) == 0
            
        else
            Tn(q,1) = avgx(i);
            Tn(q,2) = avgy(i);
            Tn(q,3) = delta*(i); 
            q = q+1;
        end
end


[idx, centroids]= kmeans(Tn,3);
compactMap = zeros(rowsn,colsn);

for j = 1:8
    [xvals,yvals] = bringxyvals(matrixret,idx,j);
    stdevx = std(xvals);
    stdevy = std(yvals);
    
    if numel(xvals) < 0.03*(rowsn*colsn)
        compactness(j) = 0;
    else
        compactness(j) = exp( (-alpha*(sqrt(stdevx^2 + stdevy^2)))/(sqrt(rowsn^2 + colsn^2)))*255;

    end
    for k = 1:numel(xvals)
       compactMap(xvals(k),yvals(k)) = compactness(j);
    end
end

maxB = max(compactMap(:));
minB = min(compactMap(:));
compactMap = (compactMap - minB) / (maxB - minB);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xvals,yvals] = bringxyvals(matrixret,idx,j1) 

[rowsn,colsn] = size(matrixret);
idxpos =zeros(256);
q = 1;

for i = 1:numel(idx)
    if idx(i) == j1
        idxpos(q) = i;
        q = q + 1;

    end
end
idxpos1 = idxpos(idxpos >0);

xyvals = zeros(rowsn*colsn,2);
p=1;

for i=1:rowsn
    for j=1:colsn
        flag = 0;
        for k2 = 1:numel(idxpos1)
            if flag == 0
            k1 = idxpos1(k2);

            if  matrixret(i,j) == k1
                
                xyvals(p,1) = i;
                xyvals(p,2) = j;
                p = p + 1;
                flag = 1;

            end
            
            end
        end

    end
end

xvals1 = xyvals(:,1);
xvals = xvals1(1:p-1);
yvals1 = xyvals(:,2);
yvals = yvals1(1:p-1);
