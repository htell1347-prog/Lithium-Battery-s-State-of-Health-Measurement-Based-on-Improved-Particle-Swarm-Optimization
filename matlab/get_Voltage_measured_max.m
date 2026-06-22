function [Voltage_measured_max] = get_Voltage_measured_max(number)

    %获取峰值电压（需要归一化）
    if number == 5
        load("B0005.mat");
        layer = 1;
        for i =1:length(B0005.cycle)
            if strcmp(B0005.cycle(i).type,'discharge')
                j = length(B0005.cycle(i).data.Voltage_measured);
                Voltage_measured_max(layer,:) = B0005.cycle(i).data.Voltage_measured(j);
                layer = layer + 1;
            end
        end

        %plot(Voltage_measured_max)
    elseif number == 6
        load("B0006.mat");
        layer = 1;
        for i =1:length(B0006.cycle)
            if strcmp(B0006.cycle(i).type,'discharge')
                j = length(B0006.cycle(i).data.Voltage_measured);
                Voltage_measured_max(layer,:) = B0006.cycle(i).data.Voltage_measured(j);
                layer = layer + 1;
            end
        end

        %plot(Voltage_measured_max)
    elseif number == 7
        load("B0007.mat");
        layer = 1;
        for i =1:length(B0007.cycle)
            if strcmp(B0007.cycle(i).type,'discharge')
                j = length(B0007.cycle(i).data.Voltage_measured);
                Voltage_measured_max(layer,:) = B0007.cycle(i).data.Voltage_measured(j);
                layer = layer + 1;
            end
        end

        %plot(Voltage_measured_max)
    elseif number == 18
        load("B0018.mat");
        layer = 1;
        for i =1:length(B0018.cycle)
            if strcmp(B0018.cycle(i).type,'discharge')
                j = length(B0018.cycle(i).data.Voltage_measured);
                Voltage_measured_max(layer,:) = B0018.cycle(i).data.Voltage_measured(j);
                layer = layer + 1;
            end
        end

        %plot(Voltage_measured_max)

    end
    
    %归一化
    for i =1:size(Voltage_measured_max,1)
        Voltage_measured_max_new(:,i) = Voltage_measured_max(i,:);
    end
    Voltage_measured_max_temp = mapminmax(Voltage_measured_max_new,0,1);
    for i =1:size(Voltage_measured_max_temp,2)
        Voltage_measured_max(i,:) = Voltage_measured_max_temp(:,i);
    end
%     maxtemp = 0.0;
%     for j =1:length(Voltage_measured_max)
%         if maxtemp < Voltage_measured_max(j)
%             maxtemp = Voltage_measured_max(j);
%         else
%             continue;
%         end
%     end
%     mintemp = 30000.0;
%     for j =1:length(Voltage_measured_max)
%         if mintemp > Voltage_measured_max(j)
%             mintemp = Voltage_measured_max(j);
%         else
%             continue;
%         end
%     end
%     for j =1:length(Voltage_measured_max)
%         Voltage_measured_max(j)=(1-0)*(Voltage_measured_max(j)-mintemp)/(maxtemp-mintemp)+0;
%     end
    %plot(Voltage_measured_max)
end


