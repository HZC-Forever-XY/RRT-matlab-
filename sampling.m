function s = sampling(xl,yl,probility,x_G,y_G)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
p = rand();
if p<=probility
    s = [x_G,y_G];
else
    s =[round(xl*rand()),round(yl*rand())];
end

