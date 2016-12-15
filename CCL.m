function output = CCL( input_bw )
I = input_bw;

currentlabel = 1;


Z = zeros(size(I));

for i = 1 : size(I,1)
    for j = 1 : size(I,2)
        if I(i,j) == 1 && Z(i,j) == 0
            UFA(currentlabel,i,j);
            currentlabel = currentlabel + 1;
        end
    end
end

    function UFA(currentlabel,i,j)
        tmpJ = j;
        while i ~= size(I,1) && I(i,j)==1
            while j ~= 1 && I(i,j-1) == 1
                j = j - 1;
            end
            while j ~= size(I,2) && I(i,j)==1
                %I(i,j) = currentlabel;
                Z(i,j) = currentlabel;
                j = j+1;
            end
            if j == size(I,2) && I(i,j)==1
                %I(i,j) = currentlabel;
                Z(i,j) = currentlabel;
            end
            if I(i,tmpJ+1) ~= 0 && I(i+1,tmpJ+1) ~= 0
                j = tmpJ+1;
            else
                j = tmpJ;
            end
            i = i+1;
        end
        if i == size(I,1)
            while j ~= 1 && I(i,j-1) == 1
                j = j - 1;
            end
            while j ~= size(I,2) && I(i,j)==1
                %I(i,j) = currentlabel;
                Z(i,j) = currentlabel;
                j = j+1;
            end
            if j == size(I,2) && I(i,j)==1
                %I(i,j) = currentlabel;
                Z(i,j) = currentlabel;
            end
        end
    end

output = Z;

end

