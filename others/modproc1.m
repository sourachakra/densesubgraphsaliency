function [vertexset2,degreenet] = modproc1(Fd,count,edgec,k1)

warning('off','MATLAB:NonIntegerInput');
clearvars edges1 a vertexset2 edgecount;
edgecount = 1;
edges1 = zeros(edgec,2);
disp(k1)
vertexset2 = zeros(1,k1);

for i= 1:count
    for j=1:count
        if i~= j && Fd(i,j)==1
           edges1(edgecount,1) = i;
           edges1(edgecount,2) = j;
           edgecount = edgecount + 1;
        end
    end
end

edgecount = edgecount - 1;
 a = randi(edgecount,[1,k1/2]);
 a = unique(a);
 a = a(a>0);

 for i = 1:length(a)
   vertexset2 = addset(vertexset2,edges1(a(i),1));
   vertexset2 = addset(vertexset2,edges1(a(i),2));
 end
 
 vertexset2 = unique(vertexset2);
 vertexset2 = vertexset2(vertexset2 > 0);

 
 
degreenet = zeros(1,length(vertexset2));

for i = 1:length(vertexset2)
    for j = 1:length(vertexset2)
      if Fd(vertexset2(i),vertexset2(j)) == 1
           degreenet(i) = degreenet(i) + 1; 
      end
    end
end


 for i1 = 1:length(vertexset2)
     for j = i1+1:length(vertexset2)
            if degreenet(i1) < degreenet(j)
                
                temp = vertexset2(i1);
                vertexset2(i1) = vertexset2(j);
                vertexset2(j)= temp;

                
                temp = degreenet(i1);
                degreenet(i1) = degreenet(j);
                degreenet(j)= temp;
                
            end
     end
 end
