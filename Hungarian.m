clc, clear;
%c = [2, 3, 5, 7; 3, 5, 2, 8; 9, 5, 7, 8; 2, 2, 3, 9];
%c = [12, 7, 9, 7, 9; 8, 9,  6, 6, 6; 7, 17, 12, 14, 12; 15, 14, 6, 6, 10; 4, 10, 7, 10, 6 ]
c=[83,61,55;54,83,33;28,109,30];
%function result = Hungarian(c)
size = length(c);
%pre-operation
line = min((c'));
line = repmat(line',1, size);
c = c - line;
column = min(c);
column = repmat(column, size, 1);
c = c - column;

%%
[axis_line, axis_column] = find(c == 0);
%C = [axis_line axis_column];
result = [axis_line, axis_column];
% [x, y] = meshgrid(temp_line, temp_column);
% result =  [x(:), y(:)];
%get the left position

%decode the matrix to three dimension
%test = cell(size, 1);
z = zeros(size, size);
for i=1:size
    x = find(result(:, 2) == i);
    temp_size = length(x);
    z(i, 1) = temp_size;
    for j = 2:temp_size+1
        test = result(x(j - 1),1);
        z(i, j) = test;
    end
end


%%
%mark
%flag = zeros(size, size);
%this loop is aimed to finding the answer for sereral iteration
tempresult = result;
while true
    %mark
    markedLine = zeros(1, size);
    markedColumn = zeros(1, size);
    [tempAnswer, all] = fit(z, 1, (1:size), zeros(1, size), []);
    left = setdiff((1:size), tempAnswer);
    if ~isempty(all)
        disp('all rolution');
        for i = 1:length(all(:, 1))
            fprintf('the %dth solution', i);
            disp(all(i, :));
        end
        break;
    end
    %mark the row
    %flag(left, :) = 1;
    markedLine(left) = 1;
    %this loop is aimed to find the possible zero
    %find all marked lines
    tmp = find(markedLine == 1);
    while true
        %for i = 1:length(tempLine)
       %%
        %step1
        %find the line(subscript)
        tmp = find(tempresult(:, 1) == tmp);
        erase = tmp;
        %find the column
        tmp = tempresult(tmp, 2);
        %find weather it is terminate
        if isempty(tmp)
            break;
        end
        %mark the column
        %flag(:,tmp) = 1;
        markedColumn(tmp) = 1;
        %erase the line
        tempresult(erase, :) = [];

       %%
        %step2
        %find the line(subscript)
        tmp = find(tempresult(:, 2) == tmp);
        erase = tmp;
        %find the line
        tmp = tempresult(tmp, 1);
        %find weather it is terminate
        if isempty(tmp)
            break;
        end
        %mark the line
        %flag(tmp, :) = 1;
        markedLine(tmp) = 1;
        %erase the column
        tempresult(erase, :) = [];
    end
    %end

    %%
     %find the minimal number
     line = markedLine;
     column = not(markedColumn);
     flag = (line')*column;
     subscript = find(flag == 1);
     min_t = findMin(c, subscript);
     %add and sub
     templine = find(markedLine == 1);
     tempcolumn = find(markedColumn == 1);
     c(templine, :) = c(templine, :) - min_t;
     c(:, tempcolumn) = c(:, tempcolumn) + min_t;
     temp = find(c(subscript) == 0);
     temp = subscript(temp);
     %for i = 1:length(temp)
         y = fix((temp-1)/5) + 1;
         x = temp - (y-1)*5;
     %end
     tempresult = [result; [x', y']];
     %check the answer                                             
     for i = 1:length(x)
         z(x(i), 1) = z(x(i), 1) + 1;
         z(x(i), z(x(i), 1)+1) = y(i); 
     end
end
result = all;