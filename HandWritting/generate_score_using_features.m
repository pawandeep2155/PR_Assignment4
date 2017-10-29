%% Load handwritting data of 3 characters.
data = load('writing_data_training.txt');

%% Set number of clusters
num_of_clusters = 8;

%% Apply K means to get discrete features.
[cluster_id,mean_kmean] = kmeans(data,num_of_clusters);

%% Store Id's in text files.

% AI File
stroke_ai = load('stroke_training_ai.txt');
file_id = fopen('hmm-1.04/id_ai.txt','w');
index = 1;

for i=1:size(stroke_ai,1)
    stroke_size = stroke_ai(i);
    fprintf(file_id,'%d \t',cluster_id(index:index+stroke_size-1));
    fprintf(file_id,'\n');
    index = index + stroke_size;
end
fclose(file_id);

% LA File
stroke_la = load('stroke_training_la.txt');
file_id = fopen('hmm-1.04/id_la.txt','w');

for i=1:size(stroke_la,1)
    stroke_size = stroke_la(i);
    fprintf(file_id,'%d \t',cluster_id(index:index+stroke_size-1));
    fprintf(file_id,'\n');
    index = index + stroke_size;
end
fclose(file_id);

% TA file
stroke_ta = load('stroke_training_ta.txt');
file_id = fopen('hmm-1.04/id_ta.txt','w');

for i=1:size(stroke_ta,1)
    stroke_size = stroke_ta(i);
    fprintf(file_id,'%d \t',cluster_id(index:index+stroke_size-1));
    fprintf(file_id,'\n');
    index = index + stroke_size;
end
fclose(file_id);

%% Find test data clusters
test_data = load('writing_data_test.txt');
test_data_cluster = zeros(size(test_data,1),1);
for i=1:size(test_data,1)
    test_data_cluster(i) = distance_to_mean(test_data(i,:)',mean_kmean,num_of_clusters);
end

%% Save test data clusters in text file.
file_id = fopen('hmm-1.04/test_id.txt','w');
stroke_ai = load('stroke_test_ai.txt');
stroke_la = load('stroke_test_la.txt');
stroke_ta = load('stroke_test_ta.txt');

index = 1;

for i=1:size(stroke_ai,1)
    stroke_size = stroke_ai(i);
    fprintf(file_id,'%d \t',test_data_cluster(index:index+stroke_size-1));
    fprintf(file_id,'\n');
    index = index + stroke_size;
end

for i=1:size(stroke_la,1)
    stroke_size = stroke_la(i);
    fprintf(file_id,'%d \t',test_data_cluster(index:index+stroke_size-1));
    fprintf(file_id,'\n');
    index = index + stroke_size;
end

for i=1:size(stroke_ta,1)
    stroke_size = stroke_ta(i);
    fprintf(file_id,'%d \t',test_data_cluster(index:index+stroke_size-1));
    fprintf(file_id,'\n');
    index = index + stroke_size;
end

fclose(file_id);

%% Distance to mean for test data
function cluster_id = distance_to_mean(data_point,mean,num_of_clusters)
    x = data_point;
    k = num_of_clusters;
    cluster_num = 0;
    min_distance = intmax('uint16');
    for i=1:k
        mean_i = mean(i,:)';
        distance = (x-mean_i)' * (x-mean_i);
        if(distance < min_distance)
            cluster_num = i;
            min_distance = distance;
        end
    end
    cluster_id = cluster_num;
end











