function [ output ] = gradient_direction( input )

%GRADIENT_direction return the absolute direction from -pi/2 to pi/2 sobel
%gradient in every point of the gradient (only half circle does not have
%negative directions
%the picture

input=double(input);%convert image to double to accumulate for negative values
%-------------------------------------------------------------------
Dy=imfilter(input,[1; -1]);%x first derivative sobel mask
Dx=imfilter(input,[1  -1]);% y sobel first derivative

%note that this expression can reach infinity if dx is zero 
%mathlab aparently get over it but you can use the folowing expression instead slower but safer: 

%output=mod(atan2(Dy,Dx)+pi(), pi());
output=(atan2(Dy,Dx)+pi());
end