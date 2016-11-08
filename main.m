input = imread('input_1.jpg');
input_bw = im2bw(input, 0.9);
input_label = bwlabel(input_bw);

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