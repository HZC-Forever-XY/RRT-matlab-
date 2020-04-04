function s = sampling(xl,yl,probility,x_G,y_G)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
p = rand();
if p<=probility
    s = [x_G,y_G];
else
    s =[round(xl*rand()),round(yl*rand())];
end

