clc
clear
N=100; %种群规模
spreadmin=-5.12;
spreadmax=5.12;
d=10;
vmax1=(spreadmax-spreadmin)*1;
vmax2=(spreadmax-spreadmin)*1;
v1max=vmax1; %粒子最大运动速度
v1min=-vmax1; %粒子最小运动速度
v2max=vmax2; %粒子最大运动速度
v2min=-vmax2; %粒子最小运动速度
% 初始化种群

for i=1:N
    for j =1:d
        pop(i,j)=spreadmin+(spreadmax-spreadmin)*rand; %初始化粒子位置
        v(i,j)=v1min+(v1max-v1min)*rand; %初始化粒子速度
    end
end

[spreadbest11,spreadbest12,pbestfitnessaveragesum1,gbestsum1]=PSOtest2(spreadmin,spreadmax,pop,v);
[spreadbest21,spreadbest22,pbestfitnessaveragesum2,gbestsum2]=IPSOtest2(spreadmin,spreadmax,pop,v);

figure(1);
plot(pbestfitnessaveragesum1,'r-');
hold on;
plot(pbestfitnessaveragesum2,'b--');
legend('PSO','IPSO');
% grid on;
% figure(2);
% plot(gbestsum1);
% hold on;
% plot(gbestsum2);
xlabel('迭代次数');
ylabel('适应度值');
legend('PSO','IPSO');
