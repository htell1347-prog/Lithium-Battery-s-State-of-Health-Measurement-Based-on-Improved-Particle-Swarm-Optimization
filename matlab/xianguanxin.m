clc
clear

trainnumber=5;
% gra
Capacity_train = get_Capacity(trainnumber);
Capacity_max_and_min = get_Capacity_max_and_min(trainnumber);
Capacity_temp = postmnmx(Capacity_train,Capacity_max_and_min(2),Capacity_max_and_min(1));
Battery_data_train = get_Battery_data(trainnumber);

Capacity_new=Capacity_temp;

for i =1:5
    
    for j =1:168
        X(j,:)=Battery_data_train(i,j);
    end
    Y=Capacity_temp;
    spreasman(i,:)=corr(X, Y, 'type', 'Spearman');
    pearson(i,:)=corr(X, Y, 'type', 'pearson');
    
end
% [coeff,score,latent,tsquared,explained,mu]=pca(T);
% gongxianzhi=latent/sum(latent);%¹±Ï×Öµ
% leijigongxianzhi=cumsum(latent)/sum(latent);%ÀÛ»ı¹±Ï×Öµ