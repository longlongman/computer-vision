function after_reduce = reduce(origin,w)
    [row,col,path] = size(origin);
    padding = zeros(row,1,path);
    origin = [padding padding origin padding padding];
    reduce_temp = zeros(row,floor(col / 2),path);
    for row_con = 1:row
        for col_con = 2:2:col
            for path_con = 1:path
                reduce_temp(row_con,floor(col_con / 2),path_con) = sum(origin(row_con,col_con + 2 - 2:col_con + 2 + 2,path_con) .* w);
            end
        end
    end
    [row,col,path] = size(reduce_temp);
    after_reduce = zeros(floor(row / 2),col,path);
    w = w';
    padding = zeros(1,col,path);
    reduce_temp = [padding;padding;reduce_temp;padding;padding];
    for col_con = 1:col
        for row_con = 2:2:row
            for path_con = 1:path
                after_reduce(floor(row_con / 2),col_con,path_con) = sum(reduce_temp(row_con + 2 - 2:row_con + 2 + 2,col_con,path_con) .* w);
            end
        end
    end
end