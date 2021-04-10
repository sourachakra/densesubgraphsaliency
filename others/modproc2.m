function [vertexset,degreenet] = modproc2(Fd,count,k1)

vertexsetin = 1:count; 

degreenode = zeros(1,count);
for i=1:count
    for j=1:count
            if(Fd(i,j) > 0)
                degreenode(i) = degreenode(i) + 1 ;
            end
    end
end



 for i1 = 1:count
     for j = i1+1:count
            if degreenode(i1) < degreenode(j)
                
                temp = vertexsetin(i1);
                vertexsetin(i1) = vertexsetin(j);
                vertexsetin(j)= temp;

                
                temp = degreenode(i1);
                degreenode(i1) = degreenode(j);
                degreenode(j)= temp;
                
            end
     end
 end
    
    
H = vertexsetin(1:ceil(k1/2));
rem = vertexsetin(ceil(k1/2)+1 : length(vertexsetin));

neighbours = zeros(1,length(rem));
for i = 1:length(rem)
    count = 0;
    for j =1:length(H)
       if Fd(rem(i),H(j)) == 1
           count = count + 1;
       end
    end
    neighbours(i) = count;
end

for i1 = 1:length(rem)
     for j = i1+1:length(rem)
            if neighbours(i1) < neighbours(j)
                
                temp = rem(i1);
                rem(i1) =rem(j);
                rem(j)= temp;
                
                temp = neighbours(i1);
                neighbours(i1) = neighbours(j);
                neighbours(j)= temp;
                
            end
     end
end
 
C = rem(1:min(ceil(k1/2),length(rem)));
vertexset = union(H,C);



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
       

