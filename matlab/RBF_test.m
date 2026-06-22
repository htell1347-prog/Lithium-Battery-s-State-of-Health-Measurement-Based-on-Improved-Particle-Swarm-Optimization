function [ty_new,test_mse,test_rmse,test_mae,test_mape] = RBF_test(net,testnumber)
    
    clc
    %网络建立和训练
    %网络建立
    
    Battery_data_test = get_Battery_data(testnumber); 
    Capacity_test = get_Capacity(testnumber);
    Capacity_max_and_min = get_Capacity_max_and_min(testnumber);

    %网络的效果验证
    %将原数据回带，测试网络效果
    %ty=sim(net,Battery_data_6);
    %ty=net(Battery_data_6);
    input=Battery_data_test;
    iw=cell2mat(net.iw(1)); %input weight，输入层到隐含层权重
    lw=cell2mat(net.lw(2,1)); %layer weight，隐含层到输出层权重
    ib=cell2mat(net.b(1)); %input bias，输入层到隐含层偏置
    lb=cell2mat(net.b(2)); %layer bias，隐含层到输出层偏置
    input_weight=dist(iw,input);
    input_bias=netprod(input_weight,ib);
    input_hidden=radbas(input_bias); %radial basis transfer function，径向基函数，使用Gauss函数
    output=dotprod(lw,input_hidden); %product of first layer output with layer weights，第一层输出与权重的乘积
    ty=netsum(output,lb); %add with layer bias，添加偏置
    
    Capacity_temp = postmnmx(Capacity_test,Capacity_max_and_min(2),Capacity_max_and_min(1));
    for i =1:size(Capacity_temp,1)
        Capacity_new(:,i) = Capacity_temp(i,:)/Capacity_max_and_min(1)*100;
    end
    
    ty_temp = postmnmx(ty,Capacity_max_and_min(2),Capacity_max_and_min(1));
    for i =1:size(ty_temp,2)
        ty_new(:,i) = ty_temp(:,i)/Capacity_max_and_min(1)*100;
    end
    
    for i =1:size(ty_new,2)
        test_error(:,i)=ty_new(:,i)-Capacity_new(:,i);
    end
    
    test_mse = mean(test_error.*test_error);    
    test_rmse = sqrt(test_mse);
    test_mae = mean(abs(test_error));
    test_mape = mean(abs(test_error./Capacity_new))*100;
end
