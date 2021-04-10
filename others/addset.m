function vertexset1 = addset(vertexset1,num)
 
 ismem = ismember(num,vertexset1);
 if ismem ==0
     b = vertexset1;
     b = b(b>0);
     vertexset1(length(b)+1) = num;
 end