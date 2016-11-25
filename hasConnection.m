function bool = hasConnection(edgesXY, n)
global edges;
bool = false;
vertex1 = edges(1, n);
vertex2 = edges(2, n);
    for i = 1 : size(edgesXY, 2)
       if edgesXY(1, i) == 1
           vertex3 = edges(1, i);
           vertex4 = edges(2, i);
           if vertex1 == vertex3 || vertex1 == vertex4 || vertex2 == vertex3 || vertex2 == vertex4
               bool = true;
           end
       end
    end
end
