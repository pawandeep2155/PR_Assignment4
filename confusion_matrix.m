%tell the parameters
class1_no_of_testing_points=30;
class2_no_of_testing_points=29;
class3_no_of_testing_points=30;

% load score of all three classes
class1_score=load('hmm_prob_ai.txt')';
class2_score=load('hmm_prob_la.txt')';
class3_score=load('hmm_prob_ta.txt')';
total_no_of_score=size(class1_score,1);

actual=zeros(3,total_no_of_score);
actual(1,1:class1_no_of_testing_points)=1;
actual(2,class1_no_of_testing_points+1:class1_no_of_testing_points + class2_no_of_testing_points)=1;
actual(3,class1_no_of_testing_points+class2_no_of_testing_points+1:total_no_of_score)=1;

predicted=zeros(3,total_no_of_score);
for i=1:total_no_of_score
    
    if(class1_score(i,1)>class2_score(i,1))
        if(class1_score(i,1)>class3_score(i,1))
            predicted(1,i)=1;
        else
            predicted(3,i)=1;
        end
    else
        if(class2_score(i,1)>class3_score(i,1))
            predicted(2,i)=1;
        else
            predicted(3,i)=1;
        end
end
end
plotconfusion(actual(:,:),predicted(:,:));
%fontsize
title('Conf Matrix, Hand Written(Normalised), k=8, isolated');
set(findobj(gca,'type','text'),'fontsize',24);
set(gca,'fontsize',24);