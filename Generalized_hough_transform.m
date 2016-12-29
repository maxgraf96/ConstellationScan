function [score] = Generalized_hough_transform(input, inputEdgeImage,template) 
%Find template/shape Itm in greyscale image Is using generalize hough trasform
%show the image with the template marked on it
%Use generalized hough transform to find Template/shape binary image given in binary image Itm inimage Is (greyscale image)
%Return the x,y location  cordniates  which gave the best match 
%Also return the score of the match (number of point matching)

%INPUT
%input is greyscale  picture were the template Itm should be found 
%template is binary edge image of the template with edges marked 1 and the rest 0

% OUTPUT
%Score of the best match

%edgeImage
edgeImage = inputEdgeImage;

%}
%--------------------------------------------------------------------------------------------------------------------------------------
[y ,x]=find(template>0); % find all coordinates which are 1 in binary image
nvs=size(x);% number of points in the template image
if (nvs<1) 
    disp('Template image is empty or faulty, terminating!'); quit() ; end
%-------------------Define Yc and Xc ----------------------------------------------
% Object center
Cy=1;%round(mean(y));% find object y center, note that any reference point will do so the origin of axis hence 1 could be used just as well
Cx=1;%round(mean(x));% find object z center, note that any reference point will do so the origin of axis hence 1 could be used just as well

%------------------------------create gradient map of template, distribution between zero to pi %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GradientMap = gradient_direction( template );

%%%%%%%%%%%%%%%%%%%%%%%Create an R-Table of template gradients to parameter space in parameter space.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The R-Table fully represents the template object
%---------------------------create template descriptor array------------------------------------
% Winkelraum in MaxAnglesBins Anzahl an "Rastern" einteilen
MaxAnglesBins=30;% divide the angle space to MaxAnglesBins uniformed space bins
MaxPointsPerangle=nvs(1);% maximal amount of points corresponding to specific angle

PointCounter=zeros(MaxAnglesBins);% counter for the amount of edge points associate with each angel gradient

% assume maximum of 100 points per angle with MaxAngelsBins angles bins between zero and pi and x,y for the vector to the center of each point
Rtable=zeros(MaxAnglesBins,MaxPointsPerangle,2);
% the third dimension are vectors from the point to the center of the image

%------------------fill the angle bins with points in the Rtable---------------------------------------------------------
for i=1:1:nvs(1)
    bin=round((GradientMap(y(i), x(i))/pi)*(MaxAnglesBins-1))+1; % transform from continuous gradient angles to discrete angle bins and 
    PointCounter(bin)=PointCounter(bin)+1;% add one to the number of points in the bin
    if (PointCounter(bin)>MaxPointsPerangle)
        disp('exceed max bin in hough transform');
    end;
    Rtable(bin, PointCounter(bin), 1) = Cy-y(i);% add the vector from the point to the object center to the bin
    Rtable(bin, PointCounter(bin), 2) = Cx-x(i);% add the vector from the point to the object center to the bin
end;
%plot(pc);
%pause;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%create and populate hough space%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------use the array in previous image to identify the template in the main image Is----------------------------------------
[y, x]=find(edgeImage>0); % find all edg point in the in edge image edgeImage of the main image input
np=size(x);% find number of edge points in edgeImage

if (np<1) 
    disp('Error: No points found in edge image, terminating!'); quit() ; 
end;

GradientMap=gradient_direction(input); % create gradient direction map of the input
Ss=size(input); % Size of the main image input
houghspace=zeros(size(input));% the hough space is assumed to be the same size of the image
    for i=1:100:np(1)
          bin=round((GradientMap(y(i), x(i))/pi)*(MaxAnglesBins-1))+1; % transform from continues gradient angles to discrete angle bins and 

          for fb=1:1:PointCounter(bin)
              ty=Rtable(bin, fb,1)+ y(i);
              tx=Rtable(bin, fb,2)+ x(i);
               if (ty>0) && (ty<Ss(1)) && (tx>0) && (tx<Ss(2)) 
                   % add point in where the center of the image should be according to the pixel gradient
                   houghspace( Rtable(bin, fb, 1) + y(i), Rtable(bin, fb, 2) + x(i) ) =  houghspace(Rtable(bin, fb,1)+ y(i), Rtable(bin, fb,2)+ x(i))+1;
               end;        
          end;
    end;

%============================================Find best match in hough space=========================================================================================

%---------------------------------------------------------------------------normalized according to template size (fraction of the template points that was found)------------------------------------------------------------------------------------------------
Itr=houghspace;% Itr become the new score matrix
Itr=Itr./sqrt(sum(sum(template)));% normalize score match by the number of pixels in the template to avoid bias toward large template
%---------------------------------------------------------------------------find  the location best score all scores which are close enough to the best score
mx=max(max(Itr));% find the max score location
[y,x]=find(Itr==mx, 1, 'first');
score=Itr(y,x); % find max score in the huogh space 

end

