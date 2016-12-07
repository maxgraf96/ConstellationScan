function BnB(edgesX)
  global solution
  global solutions
  global edgesCount
  global edges
  if sum(edgesX(1, :)) == edgesCount
      if checkSolution(edgesX)
        solutions(solution, 1: size(edgesX, 2)) = edgesX(1, :);
        solution = solution + 1;
      end
  else if size(edgesX, 2) - sum(edgesX(2, :)) + sum(edgesX(1, :)) >= edgesCount
          for i = 1 : size(edgesX, 2)
              if edgesX(2, i) == 0
                    edgesX(2, i) = 1;
                    if hasConnectionNew(edgesX, i)
                      edgesZ = edgesX;
                      edgesZ(1, i) = 1;
                      for j = 4 : size(edges,1)
                          if edges(j,i) ~= 0
                             edgesZ(2, edges(j,i)) = 1;
                          end
                      end
                      BnB(edgesZ)
                    end
              end
          end
      end
  end
end