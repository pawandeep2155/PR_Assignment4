%% Load handwritting data of 3 characters.
data = load('writing_data_training.txt');

%% Set number of clusters
num_of_clusters = 6;

%% Apply K means to get discrete features.
[cluster_id,mean_kmean] = kmeans(data,num_of_clusters);

id_ai = cluster_id(1:6170);
id_la = cluster_id(6171:10533);
id_ta = cluster_id(10534:16501);

%% Store id's in text files.
file_id = fopen('id_ai.txt','w');
fprintf(file_id,'%d',id_ai);
fclose(file_id);

file_id = fopen('id_la.txt','w');
fprintf(file_id,'%d',id_la);
fclose(file_id);

file_id = fopen('id_ta.txt','w');
fprintf(file_id,'%d',id_ta);
fclose(file_id);

%% Find test data clusters
test_data = load('writing_data_test.txt');
test_data_cluster = zeros(size(test_data,1),1);
for i=1:size(test_data,1)
    test_data_cluster(i) = distance_to_mean(test_data(i,:)',mean_kmean,num_of_clusters);
end

%% Save test data clusters in text file.
file_id = fopen('test_id.txt','w');
fprintf(file_id,'%d',test_data_cluster);
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


