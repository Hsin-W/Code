% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% �Ӻ�������ReLTanh's derivative
function nn = dev_hreltanh_opt(A, nn,i)


thp = nn.net{i}.thp;       % �����������ֵ
thn = nn.net{i}.thn;     % �����������ֵ
X  = zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ���

%�ݶ�׼��
t = tanh(A);
tt = 1 - power(t,2);
ttt = -2 * t .* tt;

% {
% С��thn�Ĳ���
idx    = find(A<thn);                               % A��С��thn��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
temp = ttt(idx);
if ~isempty(temp) & ~isempty(nn.net{i}.err(idx))
    thn = thn -  mean(mean(temp .* (nn.net{i}.err(idx))));  %
end
if thn >= -1.5
    thn = -1.5;
end
nn.net{i}.thn = thn;
X(idx) = 1-tanh(thn)^2;                           % С��thn���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ
%}

% thn��thp֮��Ĳ���
idx    = find(A<=thp& A>=thn);                % & A>=thn         
X(idx) = tt(idx);                     % sigmoid�������ֵ


% ����thp�Ĳ���
idx    = find(A>thp);  
% {
temp = ttt(idx);
if ~isempty(temp) & ~isempty(nn.net{i}.err(idx))
    thp = thp -  mean(mean(temp .* (nn.net{i}.err(idx)))) ;  %
end
if thp <= 0
    thp = 0;
end
if thp >0.5
    thp =0.5;
end
nn.net{i}.thp = thp;
X(idx) = 1-tanh(thp)^2;      % ����thp���ֵ�ʵ�����������ֵ��tanh�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ 
%}
nn.net{i}.d = X;


