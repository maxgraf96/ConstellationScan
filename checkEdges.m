function bool = checkEdges(edgesXY, n)
global edges
global checkEdges
bool = true;
vertex1 = edges(1, n);
vertex2 = edges(2, n);
countEdges = zeros(size(checkEdges));
for j = 1 : 11
   count = 0;
   for i = 1 : size(edgesXY, 2)
      if edgesXY(1, i) == 1
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
for j = 2 : size(checkEdges)
    if checkEdges(j) < countEdges(j)
        bool = false;
    end
end
end