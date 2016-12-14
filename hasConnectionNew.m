function bool = hasConnectionNew(unfSolution, checkEdge)
global edges;
global angles;
bool = false;
vertex1 = edges(1, checkEdge);
vertex2 = edges(2, checkEdge);
%first check if the edge is even possible
if checkEdges(unfSolution, checkEdge)
    for i = 1 : size(unfSolution, 2)
       if unfSolution(1, i) == 1
           vertex3 = edges(1, i);
           vertex4 = edges(2, i);
           %check if one vertex of the edge equals the vertex of our "new"
           %edge and see if it's a possible connection (otherwise the angle
           %between the 2 edges would be 0)
               if vertex1 == vertex3 && angles(vertex4, vertex2, vertex1) ~= 0
                   bool = true;
                   break;
               end
               if vertex1 == vertex4 && angles(vertex2, vertex3, vertex1) ~=0
                   bool = true;
                   break;
               end
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
