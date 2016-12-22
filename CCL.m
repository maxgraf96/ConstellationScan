%{
Connected Components Labeling:
Give every single star a label marked with 1, 2, 3, 4,... .

Input:
input_bw = image which was converted to binary image, based on threshold.

Output:
output = binary image where connected components (in this case the ones)
are combined to a uniquely labeled subset.

Algorithm:
The binary image is scrolled pixel by pixel starting from the top left,
line by line. If a unchanged pixel (ones) is found and it is not the 
background (zeros), this and every connected pixel gets an unique label (UFA). 

%}
function output = CCL( input_bw )

%Input
input = input_bw;

%Label of the current subset.
currentlabel = 1;

%Output (first a matrix of zeros)
output = zeros(size(input));


%Run through the matrix.
for i = 1 : size(input,1)
    for j = 1 : size(input,2)
        %Find an unchanged pixel, which is not the background.
        if input(i,j) == 1 && output(i,j) == 0
            UFA(currentlabel,i,j); %Set an unique label.
            currentlabel = currentlabel + 1; %Set the next label.
        end
    end
end

    %Union-Find Algorithmus:
    %Set the same unique label to this and every connected pixel.
    function UFA(currentlabel,i,j)
        %Safe column number of the first pixel.
        tmpJ = j;
        
        %Loop as long as this pixel is not in the last line and is a one.
        while i ~= size(input,1) && input(i,j)==1
            
            %Loop as long as this pixel is not in the first column and the
            %previous pixel is a one, set this column to previous column.
            while j ~= 1 && input(i,j-1) == 1
                j = j - 1;
            end
            
            %Loop as long as this pixel is not in the last column and is a
            %one, set this pixel to current label.
            while j ~= size(input,2) && input(i,j)==1
                output(i,j) = currentlabel;
                j = j+1;
            end
            
            %If this pixel is in the last column and is a one,
            %set this pixel to current label.
            if j == size(input,2) && input(i,j)==1
                output(i,j) = currentlabel;
            end
            
            %If the next pixel in the same line and the next line is 1,
            %set this column number to next column number,
            %else to this column of the first pixel.
            if input(i,tmpJ+1) ~= 0 && input(i+1,tmpJ+1) ~= 0
                j = tmpJ+1;
            else
                j = tmpJ;
            end
            i = i+1;
        end
        
        %If this pixel is in the last line.
        if i == size(input,1)
            
            %Loop as long as this pixel is not in the first column and the
            %previous pixel is a one, set this column to previous column.
            while j ~= 1 && input(i,j-1) == 1
                j = j - 1;
            end
            
            %Loop as long as this pixel is not in the last column and is a
            %one, set this pixel to current label.
            while j ~= size(input,2) && input(i,j)==1
                output(i,j) = currentlabel;
                j = j+1;
            end
            
            %If this pixel is in the last column and is a one,
            %set this pixel to current label.
            if j == size(input,2) && input(i,j)==1
                output(i,j) = currentlabel;
            end
        end
    end

%Output (solution)
output;

end

