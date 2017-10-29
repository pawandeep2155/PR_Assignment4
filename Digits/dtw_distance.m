function distance = dtw_distance(training_template,test_template)
    
    training_size = size(training_template,1);
    testing_size = size(test_template,1);

    dtw_matrix = zeros(training_size+1,testing_size+1);
    dtw_matrix_rows = size(dtw_matrix,1);
    dtw_matrix_cols = size(dtw_matrix,2);
    
    for j=2:dtw_matrix_cols
        dtw_matrix(1,j) = intmax('uint16');
    end
    
    for i=2:dtw_matrix_rows
        dtw_matrix(i,1) = intmax('uint16');
    end

    for i=2:dtw_matrix_rows
        for j=2:dtw_matrix_cols
            
            cost = euc_distance(training_template(i-1,:)',test_template(j-1,:)');
            num1 = dtw_matrix(i-1,j);
            num2 = dtw_matrix(i,j-1);
            num3 = dtw_matrix(i-1,j-1);
            
            dtw_matrix(i,j) = cost + min([num1 num2 num3]);
            
        end
    end

    distance = dtw_matrix(dtw_matrix_rows,dtw_matrix_cols);
     
end

function distance = euc_distance(vector1,vector2)
    
    diff = vector1-vector2;
    d = diff' * diff;
    distance = sqrt(d);

end





