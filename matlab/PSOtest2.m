function [spreadbest1,spreadbest2,pbestfitnessaveragesum,gbestsum] = PSOtest2(spreadmin,spreadmax,popstart,vstart)
   
    %粒子群算法
    % 设置种群参数
    N=100; %种群规模
    M=200; %最大迭代次数
    vmax1=(spreadmax-spreadmin)*1;
    vmax2=(spreadmax-spreadmin)*1;
    v1max=vmax1; %粒子最大运动速度
    v1min=-vmax1; %粒子最小运动速度
    v2max=vmax2; %粒子最大运动速度
    v2min=-vmax2; %粒子最小运动速度
    w=0.729;
    c1=1.49445; %认知学习因子,1.49445
    c2=1.49445; %社会学习因子,1.49445    
    popmax=[spreadmax,spreadmax]; %粒子最大位置（自变量最大值）
    popmin=[spreadmin,spreadmin]; %粒子最小位置（自变量最小值）   
    % 初始化种群
%     for i=1:N
%         pop(i,1)=spreadmin+(spreadmax-spreadmin)*rand; %初始化粒子位置
%         pop(i,2)=spreadmin+(spreadmax-spreadmin)*rand; %初始化粒子位置
%         v(i,1)=v1min+(v1max-v1min)*rand; %初始化粒子速度
%         v(i,2)=v2min+(v2max-v2min)*rand; %初始化粒子速度
%     end
%     load("matlab.mat");
    pop=popstart;
    v=vstart;

    popstart=pop;
    vstart=v;
    for i=1:N
        pbest(i,:)=pop(i,:); %pbest为个体最优粒子的位置,个体极值
        [test_mse] = Rosenbrock(pop(i,:));
        pbestfitness(i,:)=test_mse; %pbestfitness为个体最优粒子对应的适应值，个体极值适应度
    end

    [gbestfitness,i] = min(pbestfitness);%gbestfitness为全局最优粒子对应的适应值，群体极值适应度
    gbest=pbest(i,:); %gbest为全局最优粒子的位置，群体极值

    for t=1:M
        for i=1:N
            v(i,1)=w*v(i,1)+c1*rand*(pbest(i,1)-pop(i,1))+c2*rand*(gbest(1)-pop(i,1)); %更新粒子速度
            v(i,2)=w*v(i,2)+c1*rand*(pbest(i,2)-pop(i,2))+c2*rand*(gbest(2)-pop(i,2)); %更新粒子速度
            if v(i,1)>=v1max
                v(i,1)=v1max;
            elseif v(i,1)<v1min
                v(i,1)=v1min;
            end
            if v(i,2)>=v2max
                v(i,2)=v2max;
            elseif v(i,2)<v2min
                v(i,2)=v2min;
            end
            
            pop(i,1)=pop(i,1)+v(i,1); %更新粒子位置
            pop(i,2)=pop(i,2)+v(i,2); %更新粒子位置
            
            if pop(i,1)>=popmax(1)
                pop(i,1)=popmax(1);
            elseif pop(i,1)<popmin(1)
                pop(i,1)=popmin(1);
            end
            if pop(i,2)>=popmax(2)
                pop(i,2)=popmax(2);
            elseif pop(i,2)<popmin(2)
                pop(i,2)=popmin(2);
            end
            
            [test_mse] = Rosenbrock(pop(i,:));
            rbf_new = test_mse;
            if rbf_new<pbestfitness(i,:)
                pbestfitness(i,:)=rbf_new;
                pbest(i,:)=pop(i,:);            
            end
        end
        %采用同步更新gbest
        [gbestfitness,m] = min(pbestfitness);
        gbest=pbest(m,:);
        pbestfitnessaveragesum(t,:) = mean(pbestfitness);
        gbestsum(t,:) = gbestfitness;
        
    end
    spreadbest1=gbest(1);
    spreadbest2=gbest(2);
    
end

