function [p] = Peukert_model_train(trainnumber)
    %Peukert模型
    clc

    Capacity_train = get_Capacity(trainnumber);
    Current_measured_train = 2;
    Time_train = get_Time(trainnumber);

    %lnC-lnt=p*lnI
    %取参数p
    Capacity_train_max_and_min = get_Capacity_max_and_min(trainnumber);
    Capacity_train_temp = postmnmx(Capacity_train,Capacity_train_max_and_min(2),Capacity_train_max_and_min(1));
    for i =1:size(Capacity_train_temp,1)
        Capacity_train_ln(i,:) = log(Capacity_train_temp(i,:));
    end
    for i =1:size(Time_train,1)
        Time_train_ln(i,:) = log(Time_train(i,:)/3600);
    end
    Current_measured_train_ln = log(Current_measured_train);

    for i =1:size(Time_train,1)
        p_temp(i,:) = (Capacity_train_ln(i,:)-Time_train_ln(i,:))/Current_measured_train_ln;
    end
    p = mean(p_temp);
end

