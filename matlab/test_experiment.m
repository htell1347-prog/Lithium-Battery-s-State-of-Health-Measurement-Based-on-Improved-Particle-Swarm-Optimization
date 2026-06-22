     clc
clear

load('GA.mat');
net2=net;
load('IPSO.mat');
net4=net;

trainnumber=5;
testnumber=6;
Capacity_train = get_Capacity(testnumber);
Capacity_max_and_min = get_Capacity_max_and_min(testnumber);
Capacity_temp = postmnmx(Capacity_train,Capacity_max_and_min(2),Capacity_max_and_min(1));
for i =1:size(Capacity_temp,1)
    Capacity_new(:,i) = Capacity_temp(i,:)/Capacity_max_and_min(1)*100;
end
p=Peukert_model_train(trainnumber);

ty0=Capacity_new;%实际输出
[ty1,test_mse_1,test_rmse_1,test_mae_1,test_mape_1]=Peukert_model(p,testnumber);%Peukert
[ty2,test_mse_2,test_rmse_2,test_mae_2,test_mape_2] = RBF_test(net2,testnumber);%GA
[ty4,test_mse_4,test_rmse_4,test_mae_4,test_mape_4] = RBF_test(net4,testnumber);%IPSO

figure(1);
plot(ty0,'r-','linewidth',2);
hold on;
plot(ty1,'g-.','linewidth',2);
hold on;
plot(ty2,'b:','linewidth',2);
hold on;
plot(ty4,'m--','linewidth',2);

grid on;
% title('不同算法的预测输出');
legend('实际输出','Peukert','GA','IPSO');
xlabel('循环次数','fontSize',20);
ylabel('SOH','fontSize',20);
