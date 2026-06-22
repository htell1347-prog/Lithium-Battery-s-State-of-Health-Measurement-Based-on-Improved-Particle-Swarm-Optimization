function [Capacity_sum] = get_Capacity(number)

    %获取电池容量（需要归一化）
    if number == 5
        load("B0005.mat");
        layer = 1;
        t = 0;
        for i =1:length(B0005.cycle)
           if strcmp(B0005.cycle(i).type,'discharge')
                Capacity_sum(layer,:)=B0005.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    elseif number == 6
        load("B0006.mat");
        layer = 1;
        t = 0;
        for i =1:length(B0006.cycle)
           if strcmp(B0006.cycle(i).type,'discharge')
                Capacity_sum(layer,:)=B0006.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    elseif number == 7
        load("B0007.mat");
        layer = 1;
        t = 0;
        for i =1:length(B0007.cycle)
           if strcmp(B0007.cycle(i).type,'discharge')
                Capacity_sum(layer,:)=B0007.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    elseif number == 18
        load("B0018.mat");
        layer = 1;
        t = 0;
        for i =1:length(B0018.cycle)
           if strcmp(B0018.cycle(i).type,'discharge')
                Capacity_sum(layer,:)=B0018.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    end

    %归一化
    for i =1:size(Capacity_sum,1)
        Capacity_sum_new(:,i) = Capacity_sum(i,:);
    end
    Capacity_sum_temp = mapminmax(Capacity_sum_new,0,1);
    for i =1:size(Capacity_sum_temp,2)
        Capacity_sum(i,:) = Capacity_sum_temp(:,i);
    end
%     maxtemp = 0.0;
%     for j =1:length(Capacity_sum)
%         if maxtemp < Capacity_sum(j)
%             maxtemp = Capacity_sum(j);
%         else
%             continue;
%         end
%     end
%     mintemp = 30000.0;
%     for j =1:length(Capacity_sum)
%         if mintemp > Capacity_sum(j)
%             mintemp = Capacity_sum(j);
%         else
%             continue;
%         end
%     end
% 
%     for j =1:length(Capacity_sum)
%         Capacity_sum(j)=(1-0)*(Capacity_sum(j)-mintemp)/(maxtemp-mintemp)+0;
%     end
    
%     plot(Capacity_sum);
%     hold on;
%     plot(Capacity_sum_temp);
    
end
