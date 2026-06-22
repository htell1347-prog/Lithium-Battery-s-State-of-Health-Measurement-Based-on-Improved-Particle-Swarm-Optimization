function [get_Temperature_measured_average] = get_Temperature_measured_average(number)

    %获取平均温度（需要归一化）
    if number == 5
        load("B0005.mat");
        layer = 1;
        Temperature_measured_sum = 0.0;
        for i =1:length(B0005.cycle)
            if strcmp(B0005.cycle(i).type,'discharge')
                for j =1:length(B0005.cycle(i).data.Temperature_measured)
                    Temperature_measured_sum =Temperature_measured_sum + B0005.cycle(i).data.Temperature_measured(j);
                end
                get_Temperature_measured_average(layer,:) = Temperature_measured_sum/length(B0005.cycle(i).data.Temperature_measured);
                layer = layer + 1;
                Temperature_measured_sum = 0.0;
            end
        end

        %plot(get_Temperature_measured_average)
    elseif number == 6
        load("B0006.mat");
        layer = 1;
        Temperature_measured_sum = 0.0;
        for i =1:length(B0006.cycle)
            if strcmp(B0006.cycle(i).type,'discharge')
                for j =1:length(B0006.cycle(i).data.Temperature_measured)
                    Temperature_measured_sum =Temperature_measured_sum + B0006.cycle(i).data.Temperature_measured(j);
                end
                get_Temperature_measured_average(layer,:) = Temperature_measured_sum/length(B0006.cycle(i).data.Temperature_measured);
                layer = layer + 1;
                Temperature_measured_sum = 0.0;
            end
        end

        %plot(get_Temperature_measured_average)
    elseif number == 7
        load("B0007.mat");
        layer = 1;
        Temperature_measured_sum = 0.0;
        for i =1:length(B0007.cycle)
            if strcmp(B0007.cycle(i).type,'discharge')
                for j =1:length(B0007.cycle(i).data.Temperature_measured)
                    Temperature_measured_sum =Temperature_measured_sum + B0007.cycle(i).data.Temperature_measured(j);
                end
                get_Temperature_measured_average(layer,:) = Temperature_measured_sum/length(B0007.cycle(i).data.Temperature_measured);
                layer = layer + 1;
                Temperature_measured_sum = 0.0;
            end
        end

        %plot(get_Temperature_measured_average)
    elseif number ==18
        load("B0018.mat");
        layer = 1;
        Temperature_measured_sum = 0.0;
        for i =1:length(B0018.cycle)
            if strcmp(B0018.cycle(i).type,'discharge')
                for j =1:length(B0018.cycle(i).data.Temperature_measured)
                    Temperature_measured_sum =Temperature_measured_sum + B0018.cycle(i).data.Temperature_measured(j);
                end
                get_Temperature_measured_average(layer,:) = Temperature_measured_sum/length(B0018.cycle(i).data.Temperature_measured);
                layer = layer + 1;
                Temperature_measured_sum = 0.0;
            end
        end

        %plot(get_Temperature_measured_average)
    end
   
    %归一化
%     temp = get_Temperature_measured_average;
    for i =1:size(get_Temperature_measured_average,1)
        get_Temperature_measured_average_new(:,i) = get_Temperature_measured_average(i,:);
    end
    get_Temperature_measured_average_temp = mapminmax(get_Temperature_measured_average_new,0,1);
    for i =1:size(get_Temperature_measured_average_temp,2)
        get_Temperature_measured_average(i,:) = get_Temperature_measured_average_temp(:,i);
    end
    
%     maxtemp = 0.0;
%     for j =1:length(temp)
%         if maxtemp < temp(j)
%             maxtemp = temp(j);
%         else
%             continue;
%         end
%     end
%     mintemp = 3000.0;
%     for j =1:length(temp)
%         if mintemp > temp(j)
%             mintemp = temp(j);
%         else
%             continue;
%         end
%     end
%     for j =1:length(temp)
%         temp(j)=(1-0)*(temp(j)-mintemp)/(maxtemp-mintemp)+0;
%     end
%     plot(get_Temperature_measured_average)
%     hold on;
%     plot(temp)
end