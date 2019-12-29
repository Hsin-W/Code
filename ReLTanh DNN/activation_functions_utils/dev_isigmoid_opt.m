% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������isigmoid_opt�ĵ����������isigmoid��isigmoid_opt����ֵ��sigmoid�ĵ�����Ϊ֮���б�ʣ�
function X = dev_isigmoid_opt(A,nn)

thp = nn.opts.th_god;      % �����������ֵ
thn = -nn.opts.th_god;     % �����������ֵ
kp  = nn.opts.k_god;       % ���������б��
kn  = nn.opts.k_god;       % ���������б��
X  = zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ���

% С��thn�Ĳ���
idx    = find(A<thn);                          % A��С��thn��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
X(idx) = sigmoid(thn).*(1- sigmoid(thn));      % С��thn�Ĳ��֣���sigmoid��thn���ĵ�����Ϊб��

% thn��thp֮��Ĳ���
idx    = find(A<=thp & A>=thn);     % thn��thp֮��Ĳ��ְ�������sigmoid���㵼��
t(idx) = 1./(1 + exp(-A(idx)));
X(idx) = t(idx).*(1- t(idx));

% ����thp�Ĳ���
idx    = find(A>thp);                          % ����thp�Ĳ��֣���sigmoid��thp���ĵ�����Ϊб��
X(idx) = sigmoid(thp).*(1- sigmoid(thp));
