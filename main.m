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
angles(isnan(angles)) = 0;

%remove angles that doesnt appear in star constellation
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
               

                    
%calculate all the possible combinations for this constellation
starCount = 11;    %How many stars are in the constellation?
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
figure(1);
imshow(test);


%hough transformation
[H,T,R] = hough(test);
figure(2);
imshow(H,[],'XData', T, 'YData', R, 'InitialMagnification', 'fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));
x = T(P(:,2));
y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(test, T, R, P, 'FillGap', 5, 'MinLength', 7);
figure(3);
imshow(input), hold on;
max_length = 0;
for k = 1 : length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth', 2, 'Color', 'green');
    
    plot(xy(1,1),xy(1,2),'x', 'LineWidth', 2, 'Color', 'yellow');
    plot(xy(2,1),xy(2,2),'x', 'LineWidth', 2, 'Color', 'red');
    
    len = norm(lines(k).point1 - lines(k).point2);
    if (len > max_length)
        max_length = len;
        xy_long = xy;
    end
end























