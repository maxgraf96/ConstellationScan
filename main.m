function [output] = main(input_bw, angleTolerance)

%good score appears to be higher then 6
input_template = rgb2gray(imread('template.jpg'));

%Connected Component Labeling:
input_label = bwlabel(input_bw); %TODO: implementieren

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
angles_bigDipper = [(73 - angleTolerance), (73 + angleTolerance);
                    (79 - angleTolerance), (79 + angleTolerance);
                    (101 - angleTolerance), (101 + angleTolerance);
                    (105 - angleTolerance), (105 + angleTolerance);
                    (128 - angleTolerance), (128 + angleTolerance);
                    (140 - angleTolerance), (140 + angleTolerance);
                    (152 - angleTolerance), (152 + angleTolerance);
                    (174 - angleTolerance), (174 + angleTolerance);];
anglesCount_bigDipper = 8;

%calculate angle between all nodes
global angles;
angles = zeros(count);
allAngles = zeros(count);
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
                   allAngles(c,b,a) = angle;
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


%generate list with all edges & save the intersecting ones
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
          j = 4;
          x1 = coors(1, edges(1,n));
          y1 = coors(2, edges(1,n));
          x2 = coors(1, edges(2,n));
          y2 = coors(2, edges(2,n));
          min1X = min([x1, x2]);
          max1X = max([x1, x2]);
          min1Y = min([y1, y2]);
          max1Y = max([y1, y2]);
          for m = 1 : size(edges, 2)
            if m ~= n
                x3 = coors(1, edges(1,m));
                y3 = coors(2, edges(1,m));
                x4 = coors(1, edges(2,m));
                y4 = coors(2, edges(2,m));
                min2X = min([x3, x4]);
                max2X = max([x3, x4]);
                min2Y = min([y3, y4]);
                max2Y = max([y3, y4]);
                pX = ((x1*y2 - y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
                pY = ((x1*y2 - y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
                if min1X < pX && pX < max1X && min1Y < pY && pY < max1Y && min2X < pX && pX < max2X && min2Y < pY && pY < max2Y
                    edges(j, n) = m;
                    j = j + 1;
                end
             end
          end
    end

%set the parameters for our input and the B.I.G dipper
global edgesCount
edgesCount = 7;     %How many edges are in the constellation?
global maxEdges  %Which stars are left in the graph
maxEdges = 3;
global checkEdges
checkEdges = zeros(size(edges, 2));
checkEdges(1) = 1;
checkEdges(2) = 5;
checkEdges(3) = 1;
global circleLength
circleLength = 4;

%do dat mofuking BnB and save all possible solutions
global solution
solution = 1;
global solutions
solutions = 0;
for n = 1 : (size(edges, 2));
    edgesX = zeros(2, (size(edges, 2)));
    edgesX(1, n) = 1;
    for i = 1 : n
        edgesX(2, i) = 1;
    end
    for i = 4 : size(edges,1)
        if edges(i,n) ~= 0
            edgesX(2, edges(i,n)) = 1;
        end
    end
    BnB(edgesX);
end

scores = zeros(size(solutions, 1));

%einzeichnen
for a = 1: size(solutions, 1)
    test = input_bw;
    for b = 1 : size(solutions, 2)
        if solutions(a, b) == 1
                x1 = coors(2, edges(1, b));
                x2 = coors(2, edges(2, b));
                y1 = coors(1, edges(1, b));
                y2 = coors(1, edges(2, b));
                for n = 0:(1/round(sqrt((x2-x1)^2 + (y2-y1)^2))):1
                yn = round(x1 +(x2 - x1)*n);
                xn = round(y1 +(y2 - y1)*n);
                test(xn,yn) = 1;
                test(xn - 1,yn) = 1;
                test(xn + 1,yn) = 1;
                test(xn,yn - 1) = 1;
                test(xn,yn + 1) = 1;
                end
        end
    end

    %figure, imshow(test);
    
    %hier müsste die generalisierte hough trafo implementiert werden um zu
    %checken ob es sich bereits um das richtige bild handelt
    scores(a) = MAIN_find_object_in_image(test, input_template, a, solution-1);
    % break nur für convenience, sonst rechnet er für jeden test ~ 2 min
    % an der GHT
    % break; 
end

%Zeichnen und zurückgeben des besten bildes.
best = 1;
for i = 1:size(scores)
    if scores(i) > scores(best)
        best = i;
    end
end

output = input_bw;
for b = 1 : size(solutions, 2)
    if solutions(best, b) == 1
            x1 = coors(2, edges(1, b));
            x2 = coors(2, edges(2, b));
            y1 = coors(1, edges(1, b));
            y2 = coors(1, edges(2, b));
            for n = 0:(1/round(sqrt((x2-x1)^2 + (y2-y1)^2))):1
            yn = round(x1 +(x2 - x1)*n);
            xn = round(y1 +(y2 - y1)*n);
            output(xn,yn) = 1;
            output(xn - 1,yn) = 1;
            output(xn + 1,yn) = 1;
            output(xn,yn - 1) = 1;
            output(xn,yn + 1) = 1;
            end
    end
end
end

