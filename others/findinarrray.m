function [r,pos] = findinarrray(arr,searchnum)

arr = arr(arr>0);
l = length(arr);

pos = 1;
r=0;
for i=1:l
    if searchnum == arr(i)
        r=1;
        pos = i;
        break;
    end
end