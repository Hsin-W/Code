% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ���----��ǩ��ֵ������
% the labels are binarize
function label_ed=data_binarize(label)
label = label + 1;     % ��ʮ���Ƶı�ǩ���м�һ����Ϊ����minist���ݿ�ı�ǩ��0-9��
num_sample=length(label);     % ��ǩ�ĸ�����Ҳ���������ĸ����� length�������������ά������ά
num_label=length(unique(label));      % ������ǩ�����࣬Ҳ������������������unique(label)�޳��ظ��ģ���ÿһ��ֻ��ȡһ��������length������һ��������������Ŀ
label_ed=zeros(num_sample,num_label);    % ����������������������ƶ�ֵ����ı�ǩ�洢�������

[value,~] = max(label,[],2);    % ȷ��ÿһ�б�ǩ�����ֵ����Ϊ����1��λ��
for i=1:num_sample     % ���μ���ÿ��������ǩ
    label_ed(i,value(i)) = 1;    % �������ÿ�ж�Ӧλ�õ�0��Ϊ1
end

            
            