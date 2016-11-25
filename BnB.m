function BnB(edgesX)
  global solution
  global solutions
  global edgesCount
  global allEdges
  global edges
  if sum(edgesX(1, 1:end)) == edgesCount
      solutions(solution, 1: size(edgesX, 2)) = edgesX(1, 1:end);
      solution = solution + 1;
  else if sum(edgesX(2, :)) < allEdges - edgesCount + sum(edgesX(1, :))
          for i = 1 : size(edgesX, 2)
              if edgesX(2, i) == 0
                    if hasConnection(edgesX, i)
                      edgesY = edgesX;
                      edgesY(2, i) = 1;
                      BnB(edgesY)
                      edgesZ = edgesX;
                      edgesZ(1, i) = 1;
                      edgesZ(2, i) = 1;
                      for j = 4 : size(edges,1)
                          if edges(j,i) ~= 0
                             edgesZ(2, edges(j,i)) = 1;
                          end
                      end
                      BnB(edgesZ)
                      break
                    end
              end
          end
      end
  end
end