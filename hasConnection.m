function bool = hasConnection(edgesXY, n)
global edges;
global angles;
bool = false;
vertex1 = edges(1, n);
vertex2 = edges(2, n);
vertex1_count = 0;
vertex2_count = 0;
for i = 1 : size(edgesXY, 2)
   if edgesXY(1, i) == 1
      if edges(1, i) == vertex1 || edges(2,i) == vertex1
         vertex1_count = vertex1_count+1; 
      end
      if edges(1, i) == vertex2 || edges(2,i) == vertex2
         vertex2_count = vertex2_count+1; 
      end
   end
end
    for i = 1 : size(edgesXY, 2)
       if edgesXY(1, i) == 1
           vertex3 = edges(1, i);
           vertex4 = edges(2, i);
           if vertex1_count < 3
               if vertex1 == vertex3 && angles(vertex4, vertex2, vertex1) ~= 0
                   bool = true;
                   break;
               end
               if vertex1 == vertex4 && angles(vertex2, vertex3, vertex1) ~=0
                   bool = true;
                   break;
               end
           end
           if vertex2_count < 3
               if vertex2 == vertex3 && angles(vertex1, vertex4, vertex2) ~=0
                   bool = true;
                   break;
               end
               if vertex2 == vertex4 && angles(vertex3, vertex1, vertex2) ~=0
                   bool = true;
                   break;
               end
           end
       end
    end
end
