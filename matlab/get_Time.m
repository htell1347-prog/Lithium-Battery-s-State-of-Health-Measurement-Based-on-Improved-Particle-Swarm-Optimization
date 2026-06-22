function [Time] = get_Time(number)

    %获取放电时间（不需要归一化）
    if number == 5
        load("B0005.mat");
        layer = 1;
        for i =1:length(B0005.cycle)
            if strcmp(B0005.cycle(i).type,'discharge')
                Time(layer,:) = B0005.cycle(i).data.Time(length(B0005.cycle(i).data.Time));
                layer = layer + 1;
            end
        end

%         plot(Time)
    elseif number == 6
        load("B0006.mat");
        layer = 1;
        for i =1:length(B0006.cycle)
            if strcmp(B0006.cycle(i).type,'discharge')
                Time(layer,:) = B0006.cycle(i).data.Time(length(B0006.cycle(i).data.Time));
                layer = layer + 1;
            end
        end

        %plot(get_Current_measured_average)
    elseif number == 7
        load("B0007.mat");
        layer = 1;
        for i =1:length(B0007.cycle)
            if strcmp(B0007.cycle(i).type,'discharge')
                Time(layer,:) = B0007.cycle(i).data.Time(length(B0007.cycle(i).data.Time));
                layer = layer + 1;
            end
        end

        %plot(get_Current_measured_average)
    elseif number ==18
        load("B0018.mat");
        layer = 1;
        for i =1:length(B0018.cycle)
            if strcmp(B0018.cycle(i).type,'discharge')
                Time(layer,:) = B0018.cycle(i).data.Time(length(B0018.cycle(i).data.Time));
                layer = layer + 1;
            end
        end

        %plot(get_Current_measured_average)
    end
end

