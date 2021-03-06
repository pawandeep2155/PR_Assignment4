%% Set Training Data in terms of x,y cordinates.
data = [];

% % ai data
data_ai = dlmread('ai.ldf');
training_rows = uint16(0.7 * size(data_ai,1));
data_ai = data_ai(1:training_rows,2:size(data_ai,2));

% % la data 
data_la = dlmread('lA.ldf');
training_rows = uint16(0.7 * size(data_la,1));
data_la = data_la(1:training_rows,2:size(data_la,2));

% % ta data 
data_ta = dlmread('tA.ldf');
training_rows = uint16(0.7 * size(data_ta,1));
data_ta = data_ta(1:training_rows,2:size(data_ta,2));

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
    
    data = [data;temp];
    
end
