function den = calcdensity(Hv,Fd)

edgecount = 0;

for i = 1:length(Hv)
    for j = 1:length(Hv)
        if i~=j && Fd(Hv(i),Hv(j)) > 0
            edgecount = edgecount + 1;
        end
    end
end

den = edgecount/length(Hv);