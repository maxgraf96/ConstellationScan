input = imread('input1.jpg');
input_bw = im2bw(input, 0.9);

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
                   angles(c,b,a) = acosd(dot(vec1, vec2) / (norm(vec1) * norm(vec2)));
               end
           end
       end
   end
end

%calculate all the possible combinations for this constellation
starCount = 7;    %How many stars are in the constellation?
stars = [1,2,3,4,5,6,7,8,9,10,11];    %Which stars are left in the graph

%function
combinationCount = factorial(count) / (factorial(starCount) * factorial(count - starCount));
combinations = nchoosek(stars,starCount);

for i = 1: combinationCount
    test = input_label;
    for j = 1: starCount
        for k = 1: starCount
            if graph(j,k) == 1
                x1 = coors(2, combinations(i,j));
                x2 = coors(2, combinations(i,k));
                y1 = coors(1, combinations(i,j));
                y2 = coors(1, combinations(i,k));
                if x1 ~= x2 && y1 ~= y2
                    m = (y2 - y1)/(x2 - x1);
                    for x = x1 : x2
                        y = round(m * (x - x1) + y1);
                        test(y,x) = 1;
                        test(y + 1,x) = 1;
                        test(y - 1,x) = 1;
                        test(y,x + 1) = 1;
                        test(y,x - 1) = 1;
                    end
                end
                if x1 == x2
                    for y = y1 : y2
                        test(y,x1) = 1;
                        test(y + 1,x1) = 1;
                        test(y - 1,x1) = 1;
                        test(y,x1 + 1) = 1;
                        test(y,x1 - 1) = 1;
                    end
                end
                if y1 == y2
                    for x = x1 : x2
                        test(y1,x) = 1;
                        test(y1,x - 1) = 1;
                        test(y1,x - 1) = 1;
                        test(y1 + 1,x) = 1;
                        test(y1 - 1,x) = 1;
                    end
                end
            end
        end
    end
end

%zeigt das letzte bild, das erstellt wurde
imshow(test)




















