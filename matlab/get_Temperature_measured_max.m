function [Temperature_measured_max] = get_Temperature_measured_max(number)

    %获取最高温度（需要归一化）
    if number == 5
        load("B0005.mat");
        layer = 1;
        Temperature_measured_maxtemp = 0.0;
        for i =1:length(B0005.cycle)
            if strcmp(B0005.cycle(i).type,'discharge')
                for j =1:length(B0005.cycle(i).data.Temperature_measured)
                    if Temperature_measured_maxtemp < B0005.cycle(i).data.Temperature_measured(j)
                        Temperature_measured_maxtemp = B0005.cycle(i).data.Temperature_measured(j);
                    else
                        continue;
                    end
                end
                Temperature_measured_max(layer,:) = Temperature_measured_maxtemp;
                layer = layer + 1;
                Temperature_measured_maxtemp = 0.0;
            end
        end

        %plot(Temperature_measured_max)
    elseif number == 6
        load("B0006.mat");
        layer = 1;
        Temperature_measured_maxtemp = 0.0;
        for i =1:length(B0006.cycle)
            if strcmp(B0006.cycle(i).type,'discharge')
                for j =1:length(B0006.cycle(i).data.Temperature_measured)
                    if Temperature_measured_maxtemp < B0006.cycle(i).data.Temperature_measured(j)
                        Temperature_measured_maxtemp = B0006.cycle(i).data.Temperature_measured(j);
                    else
                        continue;
                    end
                end
                Temperature_measured_max(layer,:) = Temperature_measured_maxtemp;
                layer = layer + 1;
                Temperature_measured_maxtemp = 0.0;
            end
        end

        %plot(Temperature_measured_max)
    elseif number == 7
        load("B0007.mat");
        layer = 1;
        Temperature_measured_maxtemp = 0.0;
        for i =1:length(B0007.cycle)
            if strcmp(B0007.cycle(i).type,'discharge')
                for j =1:length(B0007.cycle(i).data.Temperature_measured)
                    if Temperature_measured_maxtemp < B0007.cycle(i).data.Temperature_measured(j)
                        Temperature_measured_maxtemp = B0007.cycle(i).data.Temperature_measured(j);
                    else
                        continue;
                    end
                end
                Temperature_measured_max(layer,:) = Temperature_measured_maxtemp;
                layer = layer + 1;
                Temperature_measured_maxtemp = 0.0;
            end
        end

        %plot(Temperature_measured_max)
    elseif number == 18
        load("B0018.mat");
        layer = 1;
        Temperature_measured_maxtemp = 0.0;
        for i =1:length(B0018.cycle)
            if strcmp(B0018.cycle(i).type,'discharge')
                for j =1:length(B0018.cycle(i).data.Temperature_measured)
                    if Temperature_measured_maxtemp < B0018.cycle(i).data.Temperature_measured(j)
                        Temperature_measured_maxtemp = B0018.cycle(i).data.Temperature_measured(j);
                    else
                        continue;
                    end
                end
                Temperature_measured_max(layer,:) = Temperature_measured_maxtemp;
                layer = layer + 1;
                Temperature_measured_maxtemp = 0.0;
            end
        end

        %plot(Temperature_measured_max)
    end


    %归一化
    for i =1:size(Temperature_measured_max,1)
        Temperature_measured_max_new(:,i) = Temperature_measured_max(i,:);
    end
    Temperature_measured_max_temp = mapminmax(Temperature_measured_max_new,0,1);
    for i =1:size(Temperature_measured_max_temp,2)
        Temperature_measured_max(i,:) = Temperature_measured_max_temp(:,i);
    end
%     maxtemp = 0.0;
%     for j =1:length(Temperature_measured_max)
%         if maxtemp < Temperature_measured_max(j)
%             maxtemp = Temperature_measured_max(j);
%         else
%             continue;
%         end
%     end
%     mintemp = 30000.0;
%     for j =1:length(Temperature_measured_max)
%         if mintemp > Temperature_measured_max(j)
%             mintemp = Temperature_measured_max(j);
%         else
%             continue;
%         end
%     end
%     for j =1:length(Temperature_measured_max)
%         Temperature_measured_max(j)=(1-0)*(Temperature_measured_max(j)-mintemp)/(maxtemp-mintemp)+0;
%     end
    %plot(Temperature_measured_max)
end
