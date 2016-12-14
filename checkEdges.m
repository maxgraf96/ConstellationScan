function bool = checkEdges(unfSolution, checkEdge)
global edges
global checkEdges
bool = true;
vertex1 = edges(1, checkEdge);
vertex2 = edges(2, checkEdge);
countEdges = zeros(size(checkEdges));
%save how often every vertex appears in the unfinished solution (incl. the
%new one)...
for j = 1 : 11
   count = 0;
   for i = 1 : size(unfSolution, 2)
      if unfSolution(1, i) == 1
          if edges(1, i) == j || edges(2, i) == j
              count = count + 1;
          end
      end
   end
   if vertex1 == j || vertex2 == j
       count = count + 1;
   end
   if count > 0
        countEdges(count) = countEdges(count) + 1;
   end
end
%...and check if the numbers are possible within our constellation
for j = 2 : size(checkEdges)
    if checkEdges(j) < countEdges(j)
        bool = false;
    end
end
end