function [y] = Schaffer4(xx)

% Schaffer函数
%%4
x1 = xx(1);
x2 = xx(2);

fact1 = (cos(sin(abs(x1^2-x2^2))))^2 - 0.5;
fact2 = (1 + 0.001*(x1^2+x2^2))^2;

y = 0.5 + fact1/fact2;
%%2
% x1 = xx(1);
% x2 = xx(2);
% 
% fact1 = (sin(x1^2-x2^2))^2 - 0.5;
% fact2 = (1 + 0.001*(x1^2+x2^2))^2;

y = 0.5 + fact1/fact2;
y = -y;%最大变最小
end

