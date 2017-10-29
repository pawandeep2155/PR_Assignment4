%% Set Training Data in terms of x,y cordinates.
data = [];

% % ai data
data_ai = dlmread('ai.ldf');
training_rows = uint16(0.7 * size(data_ai,1));
data_ai = data_ai(training_rows+1:size(data_ai,1),2:size(data_ai,2));

% % la data 
data_la = dlmread('lA.ldf');
training_rows = uint16(0.7 * size(data_la,1));
data_la = data_la(training_rows+1:size(data_la,1),2:size(data_la,2));

% % ta data 
data_ta = dlmread('tA.ldf');
training_rows = uint16(0.7 * size(data_ta,1));
data_ta = data_ta(training_rows+1:size(data_ta,1),2:size(data_ta,2));

%% Concatenate all the data
for i=1:size(data_ai,1)
    j=1;
    k=1;
    temp = [];
    run = true;
    while (j<=size(data_ai,2) && run == true)
        if(data_ai(i,j) == 0)
            run = false;
        else
            temp(k,1) = data_ai(i,j);
            temp(k,2) = data_ai(i,j+1);
        end   
        k = k+1;
        j = j+2;
        
    end
    
    mean_x = compute_mean(temp(:,1));
    std_dev_x = compute_std_deviation(temp(:,1),mean_x);
    temp(:,1) = 1/std_dev_x * (temp(:,1) - mean_x * ones(size(temp,1),1));
    
    mean_y = compute_mean(temp(:,2));
    std_dev_y = compute_std_deviation(temp(:,2),mean_y);
    temp(:,2) = 1/std_dev_y * (temp(:,2) - mean_y * ones(size(temp,1),1));
    
    data = [data;temp];
    
end

for i=1:size(data_la,1)
    j=1;
    k=1;
    temp = [];
    run = true;
    while (j<=size(data_la,2) && run == true)
        if(data_la(i,j) == 0)
            run = false;
        else
            temp(k,1) = data_la(i,j);
            temp(k,2) = data_la(i,j+1);
        end   
        k = k+1;
        j = j+2;
        
    end
    
    mean_x = compute_mean(temp(:,1));
    std_dev_x = compute_std_deviation(temp(:,1),mean_x);
    temp(:,1) = 1/std_dev_x * (temp(:,1) - mean_x * ones(size(temp,1),1));
    
    mean_y = compute_mean(temp(:,2));
    std_dev_y = compute_std_deviation(temp(:,2),mean_y);
    temp(:,2) = 1/std_dev_y * (temp(:,2) - mean_y * ones(size(temp,1),1));
    
    data = [data;temp];
    
end

for i=1:size(data_ta,1)
    j=1;
    k=1;
    temp = [];
    run = true;
    while (j<=size(data_ta,2) && run == true)
        if(data_ta(i,j) == 0)
            run = false;
        else
            temp(k,1) = data_ta(i,j);
            temp(k,2) = data_ta(i,j+1);
        end   
        k = k+1;
        j = j+2;
        
    end
    
    mean_x = compute_mean(temp(:,1));
    std_dev_x = compute_std_deviation(temp(:,1),mean_x);
    temp(:,1) = 1/std_dev_x * (temp(:,1) - mean_x * ones(size(temp,1),1));
    
    mean_y = compute_mean(temp(:,2));
    std_dev_y = compute_std_deviation(temp(:,2),mean_y);
    temp(:,2) = 1/std_dev_y * (temp(:,2) - mean_y * ones(size(temp,1),1));
    
    data = [data;temp];
    
end

function mean = compute_mean(input_data)
    data = input_data;
    sum_data = sum(data);
    data_size = size(data,1);
    
    mean = sum_data/data_size;
end

function std_deviation = compute_std_deviation(input_data,input_mean)
    data = input_data;
    mean = input_mean;
    data_size = size(data,1);
    t = data - mean * ones(data_size,1);
    t = t.*t;
    t_sum = sum(t);
    variance = t_sum/(data_size - 1);
    std_deviation = sqrt(variance);
end

