% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������isigmoid_opt�������isigmoid��isigmoid_opt��Ԥ��б�ʻ�����ֵ����sigmoid�ĵ�����
function X = isigmoid_opt(A, nn)

thp = nn.opts.th_god;      % �����������ֵ
thn = -nn.opts.th_god;     % �����������ֵ
kp  = nn.opts.k_god;       % ���������б��
kn  = nn.opts.k_god;       % ���������б��
X  = zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ���

% С��thn�Ĳ���
idx    = find(A<thn);                      % A��С��thn��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
t = 1./(1 + exp(-thn));                    % ��ʱ����������thp����sigmoid����ֵ���Լ���ó���sigmoid�ĵ���
X(idx) = t + (A(idx)-thn)*(t.*(1- t));     % С��thn���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ

% thn��thp֮��Ĳ���
idx    = find(A<=thp & A>=thn);  
X(idx) = 1./(1 + exp(-A(idx)));            % sigmoid�������ֵ

% ����thp�Ĳ���
idx    = find(A>thp);  
t = 1./(1 + exp(-thp));
X(idx) = t + (A(idx)-thp)*(t.*(1- t));     % ����thp���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ
