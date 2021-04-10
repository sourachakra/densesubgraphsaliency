function [vertexset,degreenet] = modproc3(Fd,count,k1)

vertexset =[];
maxden = 0;

for i = 1:count
    
    walkarray = 1:count;
    
    for j =1:count
        if i~=j
            num = walklen2v2w(i,j,Fd,count);
            walkarray(j) = num;
        end
    end
   
    vertexin = 1:count;

    for i1 = 1:length(walkarray)
     for j = i1+1:length(walkarray)

            if walkarray(i1) < walkarray(j)
                temp = vertexin(i1);
                vertexin(i1) = vertexin(j);
                vertexin(j)= temp;
                
                temp = walkarray(i1);
                walkarray(i1) = walkarray(j);
                walkarray(j)= temp;
                
            end
     end
    end

    kn = k1/2;
    kn = ceil(kn);
    
    Phv = vertexin(1:kn);
    
    neighbedg = zeros(1,count);
    neighb = 0;
    for i2=1:count
        if Fd(i,i2) == 1
            neighb = neighb + 1;
            count1 = 0;
            for j=1:kn
                if Fd(Phv(j),i2)==1
                    count1 = count1 + 1;
                end
            end
            neighbedg(i2) = count1 ;
        end
    end

   
    vertexin1 = 1:count;

    for i1 = 1:length(neighbedg)
     for j = i1+1:length(neighbedg)
            if neighbedg(i1) < neighbedg(j)
                
                temp = vertexin(i1);
                vertexin1(i1) = vertexin1(j);
                vertexin1(j)= temp;

                
                temp = neighbedg(i1);
                neighbedg(i1) = neighbedg(j);
                neighbedg(j)= temp;

            end
     end
    end
    
    
    Bv = vertexin1(1:kn);
    
    Hv = unique(union(Phv,Bv));

    
    
    den = calcdensity(Hv,Fd);
    if den > maxden
        maxden = den;
        vertexset = Hv;
    end
end

degreenet = zeros(1,length(vertexset));

for i = 1:length(vertexset)
    for j = 1:length(vertexset)
      if Fd(vertexset(i),vertexset(j)) == 1
           degreenet(i) = degreenet(i) + 1; 
      end
    end
end


 for i1 = 1:length(vertexset)
     for j = i1+1:length(vertexset)
            if degreenet(i1) < degreenet(j)
                
                temp = vertexset(i1);
                vertexset(i1) = vertexset(j);
                vertexset(j)= temp;

                temp = degreenet(i1);
                degreenet(i1) = degreenet(j);
                degreenet(j)= temp;
                
            end
     end
 end
 