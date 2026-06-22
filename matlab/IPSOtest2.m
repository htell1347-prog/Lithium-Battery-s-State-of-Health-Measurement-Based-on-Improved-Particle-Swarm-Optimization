function [spreadbest1,spreadbest2,pbestfitnessaveragesum,gbestsum] = IPSOtest2(spreadmin,spreadmax,popstart,vstart)

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

    popmax=[spreadmax,spreadmax]; %粒子最大位置（自变量最大值）
    popmin=[spreadmin,spreadmin]; %粒子最小位置（自变量最小值）

    
    % 初始化种群
%     for i=1:N
%         pop(i,1)=spreadmin+(spreadmax-spreadmin)*rand; %初始化粒子位置
%         pop(i,2)=spreadmin+(spreadmax-spreadmin)*rand; %初始化粒子位置
%         v(i,1)=v1min+(v1max-v1min)*rand; %初始化粒子速度
%         v(i,2)=v2min+(v2max-v2min)*rand; %初始化粒子速度
%     end
%     load("start.mat");
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
        c1=2.05; %认知学习因子,1.49445
        c2=2.05; %社会学习因子,1.49445
        c=c1+c2;
        f=2/abs(2-c-sqrt((c^2)-4*c));
        popold=pop;
        f1=c1*rand;
        f2=c2*rand;
        k=0.2;
        for i=1:N
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
            
            %f使用收缩因子
            v(i,1)=f*(v(i,1)+f1*(pbest(i,1)-(1+k)*pop(i,1)+k*popold(i,1))+f2*(gbest(1)-(1+k)*pop(i,1)+k*popold(i,1))); %更新粒子速度
            v(i,2)=f*(v(i,2)+f1*(pbest(i,2)-(1+k)*pop(i,2)+k*popold(i,2))+f2*(gbest(2)-(1+k)*pop(i,2)+k*popold(i,2))); %更新粒子速度
         
            [test_mse] = Rosenbrock(pop(i,:));
            rbf_new(i,:) = test_mse;
            if rbf_new(i,:)<pbestfitness(i,:)
                pbestfitness(i,:)=rbf_new(i,:);
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

