input = imread('input1.jpg');

input_bw = im2bw(input, 0.99);

se = strel('disk',round((sqrt(size(input_bw, 1) * size(input_bw, 2))/100)));
input_closed = imdilate(input_bw,se);

% input_closed = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1;
%                 0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1;
%                 0,0,0,0,1,0,0,1,1,1,1,0,0,0,0,0,1,1;
%                 0,1,0,1,1,1,0,1,1,1,1,0,0,0,0,0,0,1;
%                 0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0;
%                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
%                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]


input_label = bwlabel(input_closed);

output = CCL(input_closed);

