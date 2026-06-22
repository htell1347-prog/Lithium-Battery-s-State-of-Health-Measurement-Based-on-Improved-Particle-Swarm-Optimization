function [Battery_data] = get_Battery_data(number)
    
    %获取电池健康因子
%     Equal_voltage_drop_discharge_time = get_Equal_voltage_drop_discharge_time(number);
%     Isothermal_discharge_time_in_plateau_phase = get_Isothermal_discharge_time_in_plateau_phase(number);
    Temperature_measured_average = get_Temperature_measured_average(number);%平均温度（已归一化[0,1]）
    Temperature_measured_max = get_Temperature_measured_max(number);%最高温度（已归一化[0,1]）
%     Voltage_from_first_time_to_4p0V = get_Voltage_from_first_time_to_4p0V(number);
    Voltage_measured_average = get_Voltage_measured_average(number);%平均电压（已归一化[0,1]）
    Voltage_measured_max = get_Voltage_measured_max(number);%峰值电压（已归一化[0,1]）
%     Voltage_measured_min = get_Voltage_measured_min(number);
    Time_1 = get_Time(number);%放电时间（未归一化）
    for i =1:size(Time_1,1)
        Time_new(:,i) = Time_1(i,:);
    end
    Time_temp = mapminmax(Time_new,0,1);%（归一化[0,1]）
    for i =1:size(Time_temp,2)
        Time(i,:) = Time_temp(:,i);
    end
    %顺序同上
    for i =1:length(Voltage_measured_average)
%         Battery_data(6,i) = Equal_voltage_drop_discharge_time(i);
%         Battery_data(7,i) = Isothermal_discharge_time_in_plateau_phase(i);
        Battery_data(1,i) = Temperature_measured_average(i);
        Battery_data(2,i) = Temperature_measured_max(i);
%         Battery_data(8,i) = Voltage_from_first_time_to_4p0V(i);
        Battery_data(3,i) = Voltage_measured_average(i);
        Battery_data(4,i) = Voltage_measured_max(i);
%         Battery_data(9,i) = Voltage_measured_min(i);
        Battery_data(5,i) = Time(i);
    end
        
end

