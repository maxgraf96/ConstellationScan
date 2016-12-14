function BnB(edgesBnB)
  global solution
  global solutions
  global edgesCount
  global edges
  %check if there are already 7 edges in...
  if sum(edgesBnB(1, :)) == edgesCount
      ...and it's a possible solution
      if checkSolution(edgesBnB)
        solutions(solution, 1: size(edgesBnB, 2)) = edgesBnB(1, :);
        solution = solution + 1;
      end
  %otherwise put the next possible edge in our solution
  else if size(edgesBnB, 2) - sum(edgesBnB(2, :)) + sum(edgesBnB(1, :)) >= edgesCount
          for i = 1 : size(edgesBnB, 2)
              %check if we haven't considered the edge yet..
              if edgesBnB(2, i) == 0
                  edgesBnB(2, i) = 1;
                    %...and if there's a connection to our graph
                    if hasConnectionNew(edgesBnB, i)
                      %add the new edge to our graph...
                      edgesNextBnB = edgesBnB;
                      edgesNextBnB(1, i) = 1;
                      %...and mark his intersecting edges as considered
                      for j = 4 : size(edges,1)
                          if edges(j,i) ~= 0
                             edgesNextBnB(2, edges(j,i)) = 1;
                          end
                      end
                      %do it again!
                      BnB(edgesNextBnB)
                    end
              end
          end
      end
  end
end