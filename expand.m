function after_expand = expand(origin,w)
    [row,col,path] = size(origin);
    expand_temp = zeros(row * 2,col,path);
    for row_con = 1 : row
        for col_con = 1 : col
            for path_con = 1 : path
                expand_temp(row_con * 2,col_con,path_con) = origin(row_con,col_con,path_con);
            end
        end
    end
    padding = zeros(1,col,path);
    expand_temp_with_padding = [padding;padding;expand_temp;padding;padding];
    for col_con = 1 : col
        for row_con = 1 : row * 2
            for path_con = 1:path
                expand_temp(row_con,col_con,path_con) = 2 * sum(expand_temp_with_padding(row_con + 2 - 2:row_con + 2 + 2,col_con,path_con) .* w');
            end
        end
    end
    after_expand = zeros(row * 2,col * 2,path);
    for row_con = 1:row * 2
        for col_con = 1:col
            for path_con = 1:path
                after_expand(row_con,col_con * 2,path_con) = expand_temp(row_con,col_con,path_con);
            end
        end
    end
    padding = zeros(row * 2,1,path);
    after_expand_with_padding = [padding padding after_expand padding padding];
    for row_con = 1:row * 2
        for col_con = 1:col * 2
            for path_con = 1:path
                after_expand(row_con,col_con,path_con) = 2 * sum(after_expand_with_padding(row_con,col_con + 2 - 2:col_con + 2 + 2,path_con) .* w);
            end
        end
    end
end