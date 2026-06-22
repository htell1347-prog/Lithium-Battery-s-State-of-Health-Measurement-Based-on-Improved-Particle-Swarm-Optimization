function [Capacity_max_and_min] = get_Capacity_max_and_min(number)
    
    %获取最大和最小电池容量
    if number == 5
        load("B0005.mat");
        layer = 1;
        for i =1:length(B0005.cycle)
           if strcmp(B0005.cycle(i).type,'discharge')
                Capacity(layer,:)=B0005.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    elseif number == 6
        load("B0006.mat");
        layer = 1;
        for i =1:length(B0006.cycle)
           if strcmp(B0006.cycle(i).type,'discharge')
                Capacity(layer,:)=B0006.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    elseif number == 7
        load("B0007.mat");
        layer = 1;
        for i =1:length(B0007.cycle)
           if strcmp(B0007.cycle(i).type,'discharge')
                Capacity(layer,:)=B0007.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    elseif number == 18
        load("B0018.mat");
        layer = 1;
        for i =1:length(B0018.cycle)
           if strcmp(B0018.cycle(i).type,'discharge')
                Capacity(layer,:)=B0018.cycle(i).data.Capacity;
               layer = layer + 1;
            end
        end
        %plot(SOH_sum)
    end

    %寻找容量
    Capacity_max_and_min(1) = max(Capacity);
    Capacity_max_and_min(2) = min(Capacity);    
%     maxtemp = 0.0;
%     for j =1:length(Capacity)
%         if maxtemp < Capacity(j)
%             maxtemp = Capacity(j);
%         else
%             continue;
%         end
%     end
%     mintemp = 30000.0;
%     for j =1:length(Capacity)
%         if mintemp > Capacity(j)
%             mintemp = Capacity(j);
%         else
%             continue;
%         end
%     end
% 
%     Capacity_max_and_min(1) = maxtemp;
%     Capacity_max_and_min(2) = mintemp;

end
