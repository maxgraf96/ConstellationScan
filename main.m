clear all
input = imread('input1.jpg');
input_bw = im2bw(input, 0.9);
input_template = imread('template_sauber.jpg');
input_template = im2bw(input_template, 0.8);
imshow(input_template);

MAIN_find_object_in_image(input_template, input_template);
%Connected Component Labeling:
input_label = bwlabel(input_bw); %TODO: implementieren

%get pixels of component
%{
[r, c] = find(input_label==19);
rc = [r c]
%}

%draw line between two pixels
%x0 = 340, y0 = 150 // x1 = 213, y1 = 258
%{
for n = 0:(1/round(sqrt((213-340)^2 + (258-150)^2))):1
xn = round(340 +(213 - 340)*n);
yn = round(150 +(258 - 150)*n);
input_bw(xn,yn) = 1;
end
%}

count = max(input_label(:));

%generate full graph
graph = ones(count);
for n = 1:count
   graph(n,n) = 0;
end

%save coordinates for each node
coors = zeros(2,count);
for n = 1:count
   [row,col] = find(input_label == n);
   coors(:,n) = [row(1); col(1)];
end

%save all angles in big Dipper (Großer Wagen)
angles_bigDipper = [0.1, 3.6;
                    4.8, 7.3;
                    7.9, 10.0;
                    11.5, 12.8;
                    14.2, 16.4;
                    16.6, 20.6;
                    21.1, 22.3;
                    22.6, 25.7;
                    27.3, 28.3;
                    28.9, 31.2;
                    33.6, 36.0;
                    39.1, 40.1;
                    41.3, 42.3;
                    48.6, 50.3;
                    52.0, 53.0;
                    73.6, 76.8;
                    80.1, 81.1;
                    82.7, 83.9;
                    84.2, 85.2;
                    88.2, 89.2;
                    99.8, 100.8;
                    103.3, 105.4;
                    109.3, 110.3;
                    113.9, 114.9;
                    126.1, 129.7;
                    133.8, 134.8;
                    137.1, 138.1;
                    139.7, 140.8;
                    142.5, 143.9;
                    149.6, 150.6;
                    152.2, 153.2;
                    155.8, 156.8;
                    157.0, 158.0;
                    158.1, 159.8;
                    161.0, 162.4;
                    163.8, 165.4;
                    173.7, 174.7;
                    176.0, 177.0;
                    178.6, 180.0];
anglesCount_bigDipper = 39;

%calculate angle between all nodes
angles = zeros(count);
for a = 1:count
   mainnode = [coors(1,a), coors(2,a)];
   for b = 1:count
       if a ~= b
           extnode1 = [coors(1,b), coors(2,b)];
           for c = 1:count
               if b ~= c
                   extnode2 = [coors(1,c), coors(2,c)];
                   vec1 = mainnode - extnode1;
                   vec2 = mainnode - extnode2;
                   angle = acosd(dot(vec1, vec2) / (norm(vec1) * norm(vec2)));
                   %only add angles that could possibly appear in the
                   %constellation
                   possible = false;
                   for i = 1 : anglesCount_bigDipper
                       if angle >= angles_bigDipper(i, 1) && angle <= angles_bigDipper(i, 2)
                           possible = true;
                           break
                       end
                   end
                   if possible == true
                       angles(c,b,a) = angle;
                   else
                       angles(c,b,a) = 0;
                   end
               end
           end
       end
   end
end
angles(isnan(angles)) = 0;        
                    
%set the parameters for our input and the B.I.G dipper
global edgesCount
edgesCount = 7;     %How many edges are in the constellation?
global maxEdges  %Which stars are left in the graph
maxEdges = 3;


%generate list with all edges && save the intercecting ones
global edges;
    j = 1;
    for n = 1 : count
       for m = n : count
           if graph(n,m) == 1
              edges(1,j) = n;
              edges(2,j) = m;
              j = j + 1;
           end
       end
    end
    for n = 1 : size(edges, 2)
          count = 4;
          x1 = coors(1, edges(1,n));
          y1 = coors(2, edges(1,n));
          x2 = coors(1, edges(2,n));
          y2 = coors(2, edges(2,n));
          for m = 1 : size(edges, 2)
            if m ~= n
                x3 = coors(1, edges(1,m));
                y3 = coors(2, edges(1,m));
                x4 = coors(1, edges(2,m));
                y4 = coors(2, edges(2,m));
                minX = min([x1, x2, x3, x4]);
                maxX = max([x1, x2, x3, x4]);
                minY = min([y1, y2, y3, y4]);
                maxY = max([y1, y2, y3, y4]);
                pX = ((x1*y2 - y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
                pY = ((x1*y2 - y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
                if minX < pX && pX < maxX && minY < pY && pY < maxY
                    edges(count, n) = m;
                    count = count + 1;
                end
             end
          end
    end
    

%do dat mofuking BnB and save all possible solutions
global allEdges
allEdges = size(edges,2);
global solution
solution = 1;
global solutions
solutions = 0;
for n = 1 : (size(edges, 2));
    edgesX = zeros(2, (size(edges, 2)));
    edgesX(1, n) = 1;
    edgesX(2, n) = 1;
    for i = 4 : size(edges,1)
        if edges(i,n) ~= 0
            edgesX(2, edges(i,n)) = 1;
        end
    end
    BnB(edgesX);
end

%einzeichnen
for a = 1: size(solutions, 1)
    test = input_label;
    for b = 1 : size(solutions, 2)
        if solutions(a, b) == 1
                x1 = coors(2, edges(1, b));
                x2 = coors(2, edges(2, b));
                y1 = coors(1, edges(1, b));
                y2 = coors(1, edges(2, b));
                if x1 > x2
                    tmp = x1;
                    x1 = x2;
                    x2 = tmp;
                    tmp = y1;
                    y1 = y2;
                    y2 = tmp;
                end
                if x1 ~= x2
                    m = (y2 - y1)/(x2 - x1);
                else
                    m = 1;
                end
                for x = x1 : x2
                    y = round(m * (x - x1) + y1);
                    test(y,x) = 1;
                    test(y + 1,x) = 1;
                    test(y - 1,x) = 1;
                    test(y,x + 1) = 1;
                    test(y,x - 1) = 1;
                end
        end
    end
    
    %hier müsste die generalisierte hough trafo implementiert werden um zu
    %checken ob es sich bereits um das richtige bild handelt
    MAIN_find_object_in_image(test, input_template);
    % break nur für convenience, sonst rechnet er für jeden test ~ 2 min
    % an der GHT
    % break; 
    
    
end


%zeigt das letzte bild, das erstellt wurde (zu testzwecken)
figure(1);
imshow(test);