function n = walklen2v2w(u,v,Fd,count)

n=0;
for i = 1:count
    if i ~= u && i~=v && Fd(i,u) == 1 && Fd(i,v) == 1
        n = n+1;
    end
end