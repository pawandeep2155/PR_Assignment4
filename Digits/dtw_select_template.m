%% Get data of all 3 words.

% Load 1 digit file.
files1=dir(fullfile('isolated/1/*.mfcc'));
num_of_files = length(files1); 
data_1 = cell(1,num_of_files);

for k=1:num_of_files
    file_name=files1(k).name;
    final_route=strcat('isolated/1/',file_name);
    data =dlmread(final_route,' ' ,1,0); %reding file without 1 row because 1st row have dimensions
    data(:,1) = [];
    data_1{k} = data;
end

% Load 2 digit file.
files2=dir(fullfile('isolated/2/*.mfcc'));
num_of_files = length(files2); 
data_2 = cell(1,num_of_files);

for k=1:num_of_files
    file_name=files2(k).name;
    final_route=strcat('isolated/2/',file_name);
    data =dlmread(final_route,' ' ,1,0); %reding file without 1 row because 1st row have dimensions
    data(:,1) = [];
    data_2{k} = data;
end

% Load z digit file.
filesz=dir(fullfile('isolated/z/*.mfcc'));
num_of_files = length(filesz); 
data_z = cell(1,num_of_files);

for k=1:num_of_files
    file_name=filesz(k).name;
    final_route=strcat('isolated/z/',file_name);
    data =dlmread(final_route,' ' ,1,0); %reding file without 1 row because 1st row have dimensions
    data(:,1) = [];
    data_z{k} = data;
end

%% Extract Training_data

training_rows_1 = uint16(size(data_1,2) * .7);
train_data_1 = cell(1,training_rows_1);
for i=1:training_rows_1
    train_data_1(i) = data_1(i);
end

training_rows_2 = uint16(size(data_2,2) * .7);
train_data_2 = cell(1,training_rows_2);

for i=1:training_rows_2
    train_data_2(i) = data_2(i);
end

training_rows_z = uint16(size(data_z,2) * .7);
train_data_z = cell(1,training_rows_z);

for i=1:training_rows_z
    train_data_z(i) = data_z(i);
end

%% Extract Validation Data

valid_rows_1 = uint16(size(data_1,2) * .15);
valid_data_1 = cell(1,valid_rows_1);
for i=1:valid_rows_1
    valid_data_1(i) = data_1(training_rows_1+i);
end

valid_rows_2 = uint16(size(data_2,2) * .15);
valid_data_2 = cell(1,valid_rows_2);
for i=1:valid_rows_2
    valid_data_2(i) = data_2(training_rows_2+i);
end

valid_rows_z = uint16(size(data_z,2) * .15);
valid_data_z = cell(1,valid_rows_z);
for i=1:valid_rows_z
    valid_data_z(i) = data_z(training_rows_z+i);
end

%% Run Validation Data against Triaining Data to select best template from training Data.

% Template selection for digit 1
dist_matrix_digit1 = zeros(training_rows_1,valid_rows_1);

for v=1:valid_rows_1
    
    validation_data = valid_data_1{v};
    
    for t=1:training_rows_1
        
        training_data = train_data_1{t};
        dist_matrix_digit1(t,v) = dtw_distance(training_data,validation_data);
        
    end
end

% Template selection for digit 2
dist_matrix_digit2 = zeros(training_rows_2,valid_rows_2);

for v=1:valid_rows_2
    
    validation_data = valid_data_2{v};
    
    for t=1:training_rows_2
        
        training_data = train_data_2{t};
        dist_matrix_digit2(t,v) = dtw_distance(training_data,validation_data);
        
    end
end

% Template selection for digit z
dist_matrix_digitz = zeros(training_rows_z,valid_rows_z);

for v=1:valid_rows_z
    
    validation_data = valid_data_z{v};
    
    for t=1:training_rows_z
        
        training_data = train_data_z{t};
        dist_matrix_digitz(t,v) = dtw_distance(training_data,validation_data);
        
    end
end


% Find the best template from distance matrix
[~,ii] = min(dist_matrix_digitz',[],2);

%% Extract testing data.
test_rows_1 = floor(size(data_1,2) * .15);
test_data_1 = cell(1,test_rows_1);
for i=1:test_rows_1
    test_data_1(i) = data_1(training_rows_1 + valid_rows_1 + i);
end

test_rows_2 = floor(size(data_2,2) * .15);
test_data_2 = cell(1,test_rows_2);
for i=1:test_rows_2
    test_data_2(i) = data_2(training_rows_2 + valid_rows_2 + i);
end

test_rows_z = floor(size(data_z,2) * .15);
test_data_z = cell(1,test_rows_z);
for i=1:test_rows_z
    test_data_z(i) = data_z(training_rows_z + valid_rows_z + i);
end

testing_data = [test_data_1 test_data_2 test_data_z];

%% Testing data against found templates.
% Template for Digit 1 = 1,17,33. 
% Template for Digit 2 = 16,28,29.
% Template for Digit z = 35,17,22.

actual_score = ones(1,test_rows_1+test_rows_2+test_rows_z);
predicted_score = ones(1,test_rows_1+test_rows_2+test_rows_z);

for i=test_rows_1+1:test_rows_1+test_rows_2
    actual_score(i) = 2;
end
for i=test_rows_1+test_rows_2+1:test_rows_1+test_rows_2+test_rows_z
    actual_score(i) = 3;
end

% Test against Digit 1 template.
template1 = train_data_1{1};
template2 = train_data_1{17};
template3 = train_data_1{33};

score_class1 = zeros(test_rows_1+test_rows_2+test_rows_z,1);

for i=1:test_rows_1+test_rows_2+test_rows_z
    
    test_data = testing_data{i};
    
    % Run against template1
    score_temp1 = dtw_distance(template1,test_data);

    % Run against template2
    score_temp2 = dtw_distance(template2,test_data);
    
    % Run against template3
    score_temp3 = dtw_distance(template3,test_data);

    score_class1(i) = min([score_temp1 score_temp2 score_temp3]);
    
end

% Test against Digit 2 template.
template1 = train_data_2{16};
template2 = train_data_2{28};
template3 = train_data_2{29};

score_class2 = zeros(test_rows_1+test_rows_2+test_rows_z,1);

for i=1:test_rows_1+test_rows_2+test_rows_z
    
    test_data = testing_data{i};
    
    % Run against template1
    score_temp1 = dtw_distance(template1,test_data);

    % Run against template2
    score_temp2 = dtw_distance(template2,test_data);
    
    % Run against template3
    score_temp3 = dtw_distance(template3,test_data);

    score_class2(i) = min([score_temp1 score_temp2 score_temp3]);
    
end


% Test against Digit 3 template.
template1 = train_data_z{35};
template2 = train_data_z{17};
template3 = train_data_z{22};

score_class3 = zeros(test_rows_1+test_rows_2+test_rows_z,1);

for i=1:test_rows_1+test_rows_2+test_rows_z
    
    test_data = testing_data{i};
    
    % Run against template1
    score_temp1 = dtw_distance(template1,test_data);

    % Run against template2
    score_temp2 = dtw_distance(template2,test_data);
    
    % Run against template3
    score_temp3 = dtw_distance(template3,test_data);

    score_class3(i) = min([score_temp1 score_temp2 score_temp3]);
    
end

%% Plot confusion Matrix.
actual=zeros(3,test_rows_1+test_rows_2+test_rows_z);
actual(1,1:test_rows_1)=1;
actual(2,test_rows_1+1:test_rows_1+test_rows_2)=1;
actual(3,test_rows_1+test_rows_2+1:test_rows_1+test_rows_2+test_rows_z)=1;

predicted=zeros(3,test_rows_1+test_rows_2+test_rows_z);

for i=1:test_rows_1+test_rows_2+test_rows_z
    
    [M,I] = min([score_class1(i) score_class2(i) score_class3(i)]);
    predicted(I,i) = 1;
end

plotconfusion(actual(:,:),predicted(:,:));
%fontsize
title('Conf Matrix, Digit Data, Isolated, 100%');
set(findobj(gca,'type','text'),'fontsize',24);
set(gca,'fontsize',24);










