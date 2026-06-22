function [ty_new,test_mse,test_rmse,test_mae,test_mape] = Peukert_model(p,testnumber)
    %Peukert模型
    clc

    Capacity_test = get_Capacity(testnumber);
    Current_measured_test = 2;
    Time_test = get_Time(testnumber);
   
    %C=exp(p*lnI+lnt)
    %Peukert模型预测电池容量
    for i =1:size(Time_test,1)
        Time_test_ln(i,:) = log(Time_test(i,:)/3600); 
    end
    Current_measured_test_ln = log(Current_measured_test);
    for i =1:size(Time_test_ln,1)
        ty_temp(i,:) = exp(p*Current_measured_test_ln + Time_test_ln(i,:));
    end
 
    Capacity_test_max_and_min = get_Capacity_max_and_min(testnumber);
    
    Capacity_temp = postmnmx(Capacity_test,Capacity_test_max_and_min(2),Capacity_test_max_and_min(1));
    for i =1:size(Capacity_temp,1)
        Capacity_new(:,i) = Capacity_temp(i,:)/Capacity_test_max_and_min(1)*100;
    end
    
%     ty_temp = postmnmx(ty,Capacity_max_and_min(2),Capacity_max_and_min(1));
    for i =1:size(ty_temp,1)
        ty_new(:,i) = ty_temp(i,:)/Capacity_test_max_and_min(1)*100;
    end
    
    for i =1:size(ty_new,2)
        test_error(:,i)=ty_new(:,i)-Capacity_new(:,i);
    end

    test_mse = mean(test_error.*test_error);    
    test_rmse = sqrt(test_mse);
    test_mae = mean(abs(test_error));
    test_mape = mean(abs(test_error./Capacity_new))*100;    
    
end

