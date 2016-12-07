function bool = checkSolution(edgesXY)
global edges
global checkEdges
global circleLength
bool = true;
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
   if count > 0
        countEdges(count) = countEdges(count) + 1;
   end
end
for j = 1 : size(checkEdges)
    if checkEdges(j) ~= countEdges(j)
        bool = false;
    end
end

circle = false;

for i = 1 : size(edgesXY, 2)
    if edgesXY(1, i) == 1
        edgesY = zeros(size(edgesXY, 2));
        edgesY(i) = 1;
        startVertex = edges(1, i);
        nextVertex = edges(2, i);
        count = 1;
        while count < 4
            temp = nextVertex;
            for j = 1 : size(edgesXY, 2)
                if edgesXY(1, j) == 1 && edgesY(j) == 0
                    if edges(1, j) == nextVertex
                        nextVertex = edges(2,j);
                        count = count + 1;
                        break;
                    elseif edges(2, j) == nextVertex
                        nextVertex = edges(1,j);
                        count = count + 1;
                        break;
                    end
                end
            end
            if nextVertex == temp
                break;
            end
        end
        if count == circleLength && startVertex == nextVertex
            circle = true;
        end
    end
end

if circle == false
    bool = false;
end

end