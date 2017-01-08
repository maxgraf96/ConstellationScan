function bool = checkSolution(edgesSolution)
global edges
global checkEdges
global circleLength
global starsCount
global angles
global angles_bigDipper
bool = true;
starArray = zeros(3, 5);
countEdges = zeros(size(checkEdges));
%save how often every vertex appears in the solution...
for j = 1 : starsCount
   count = 0;
   for i = 1 : size(edgesSolution, 2)
      if edgesSolution(1, i) == 1
          if edges(1, i) == j || edges(2, i) == j
              count = count + 1;
          end
      end
   end
   if count > 0
        countEdges(count) = countEdges(count) + 1;
        starArray(count, countEdges(count)) = j;
   end
   
end
%...and check if the results are the same as in the constellation
for j = 1 : size(checkEdges)
    if checkEdges(j) ~= countEdges(j)
        bool = false;
    end
end

nextStar = 0;
for i = 1 : size(edgesSolution, 2)
      if edgesSolution(1, i) == 1
          if edges(1, i) == starArray(1,1) || edges(2, i) == starArray(1,1)
              if edges (1, i ) == starArray(1,1)
                  nextStar = edges(2, i);
              else
                  nextStar = edges(1, i);
              end      
          end
      end
end
nextNextStar = 0;
if nextStar ~= 0
    for j = 1 : size(starArray, 2)
         if starArray(2, j) == nextStar
             for i = 1 : size(edgesSolution, 2)
              if edgesSolution(1, i) == 1
                  if (edges(1, i) == nextStar || edges(2, i) == nextStar) && edges(1, i) ~= starArray(1,1) && edges(2, i) ~= starArray(1,1)
                      if edges (1, i ) == nextStar
                          nextNextStar = edges(2, i);
                      else
                          nextNextStar = edges(1, i);
                      end      
                  end
              end
             end
         end
    end
end
checkStar = 0;
if nextNextStar ~= 0  
    for j = 1 : size(starArray, 2)
         if starArray(2, j) == nextNextStar
             for i = 1 : size(edgesSolution, 2)
              if edgesSolution(1, i) == 1
                  if (edges(1, i) == nextNextStar || edges(2, i) == nextNextStar) && edges(1, i) ~= nextStar && edges(2, i) ~= nextStar
                      if edges (1, i ) == nextNextStar
                          checkStar = edges(2, i);
                      else
                          checkStar = edges(1, i);
                      end      
                  end
              end
             end
         end
    end
end
if starArray(3,1) ~= checkStar
    bool = false;
end
if starArray(3,1) == checkStar && checkStar ~= 0
    if angles(starArray(1,1), nextNextStar, nextStar) < angles_bigDipper(6, 1) || angles(starArray(1,1), nextNextStar, nextStar) > angles_bigDipper(6, 2)
        bool = false;
    end
    if angles(nextStar, checkStar, nextNextStar) < angles_bigDipper(8, 1) || angles(nextStar, checkStar, nextNextStar) > angles_bigDipper(8, 2)
        bool = false;
    end   
end
%check if there is a cirlce with the length 4 in our solution
circle = false;
for i = 1 : size(edgesSolution, 2)
    if edgesSolution(1, i) == 1
        edgesY = zeros(size(edgesSolution, 2));
        edgesY(i) = 1;
        startVertex = edges(1, i);
        nextVertex = edges(2, i);
        count = 1;
        while count < 4
            temp = nextVertex;
            for j = 1 : size(edgesSolution, 2)
                if edgesSolution(1, j) == 1 && edgesY(j) == 0
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

%if there is no circle, the solution is not possible
if circle == false
    bool = false;
end

end