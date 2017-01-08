function [BestScore]= GHT(input,template, current,total)
%{
Input:
input: One of the solutions from BnB algorithm.
template: Template of the object to be found as a binary image. Only the
edges are stored (white boundaries).
current: index of current solution we are looking at.
total: number of solutions to be looked at.

Output:
BestScore: Score of the best match found in the scan.
%}

template = logical(template); % make sure template is boolean image
BestScore = -100000;

% edgeImage is calculated outside the loop because it is always the same
input = imresize(input, size(template));
%edgeImage = edge(input,'canny');

for Ang = 0 : 2 : 360 % rotate the template 5 degres at a time and look for it in the input image 
    disp(['100% BnB ' num2str(round((((Ang) / 3.6) + (current - 1) * 100) / total)) '% GHT']);
    template_rotated = imrotate(template,Ang);
  
    score = Generalized_hough_transform(input, input, template_rotated);
     % save the best score
     if (score > BestScore)
         BestScore=score;
     end
end;
end