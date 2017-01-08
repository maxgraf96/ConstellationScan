function [score] = Generalized_hough_transform(input, inputEdgeImage, template)
%{
INPUT:
input: image where the constellation should be found.
template: is binary edge image of the template with edges marked 1 and the
rest 0.

OUTPUT:
score: Score of the best match
%}
edgeImage = inputEdgeImage;

[y ,x] = find(template > 0); % find all coordinates which are 1 in the template
pointsInTemplate = size(x);% number of points in the template image
if (pointsInTemplate < 1) 
    disp('Template image is empty or faulty. Terminating...'); quit() ;
end

% Object center
Cy = round(mean(y));
Cx = round(mean(x));

% create gradient map of template, values between zero to pi 
GradientMap = gradient_direction(template);

% Create an R-Table of template gradients to parameter space.
% The R-Table fully represents the template object
MaxAnglesBins = 30;% divide the angle space to MaxAnglesBins uniformed space bins
MaxPointsPerangle = pointsInTemplate(1); % maximal amount of points corresponding to specific angle

PointCounter = zeros(MaxAnglesBins); % counter for the amount of edge points associated with each angel gradient

% assume maximum of 100 points per angle with MaxAngelsBins angles bins between zero and pi and x,y for the vector to the center of each point
% in the second dimension we store the vectors from the point to the center of the
% image
Rtable = zeros(MaxAnglesBins, MaxPointsPerangle, 2); % in this case 30 x 6000 x 2


% fill the angle bins with points in the Rtable
for i = 1 : 1 : pointsInTemplate(1)
    bin = round((GradientMap(y(i), x(i)) / pi) * (MaxAnglesBins - 1)) + 1; % transform from continuous gradient angles to discrete angle bins and 
    PointCounter(bin) = PointCounter(bin) + 1;% add one to the number of points in the bin
    if (PointCounter(bin) > MaxPointsPerangle)
        disp('exceed max bin in hough transform');
    end;
    % add the vector from the intersection point to the object center to
    % the R-Table (r = Cpoint - p)
    Rtable(bin, PointCounter(bin), 1) = Cy - y(i);
    Rtable(bin, PointCounter(bin), 2) = Cx - x(i);
end;

% create and populate hough space
% use the array in previous image to identify the template in the main
% image 'input'
[y, x] = find(edgeImage > 0); % find all edge points in the edgeImage
pointsInEdgeImage = size(x);

if (pointsInEdgeImage < 1) 
    disp('Error: No points found in edge image. Terminating...'); quit() ; 
end;

GradientMap = gradient_direction(input); % create gradient direction map of the input
Ss = size(input); % Size of the main image input
houghspace = zeros(size(input));% the hough space is assumed to be of the same size as the image
    for i = 1 : 1 : pointsInEdgeImage(1)
          bin = round((GradientMap(y(i), x(i))/pi) * (MaxAnglesBins-1)) + 1; % transform from continues gradient angles to discrete angle bins
          for point = 1 : 1 : PointCounter(bin)
              ty = Rtable(bin, point, 1) + y(i);
              tx = Rtable(bin, point, 2) + x(i);
               if (ty > 0) && (ty < Ss(1)) && (tx > 0) && (tx < Ss(2)) 
                   % add point where the center of the template image should be according to the pixel gradient
                   houghspace( ty, tx ) =  houghspace( ty, tx ) + 1;
               end;        
          end;
    end;

% normalized according to template size (fraction of the template points
% which were found)
houghNormalized = houghspace;% Itr becomes the new score matrix
houghNormalized = houghNormalized ./ sqrt(sum(sum(template)));% normalize score match by the number of pixels in the template to avoid bias towards large template

score = max(max(houghNormalized)); % find the max score 

end

