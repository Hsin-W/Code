% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������isigmoid�������sigmoid��isigmoid��������ֵ֮��Ĳ��ֻ����˹̶�б�ʵ�ֱ�ߣ�
function X = isigmoid(A, nn)

thp = nn.opts.th_god;      % �����������ֵ
thn = -nn.opts.th_god;     % �����������ֵ
kp  = nn.opts.k_god;       % ���������б��
kn  = nn.opts.k_god;       % ���������б��
X  = zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ���

% С��thn�Ĳ���
idx    = find(A<thn);                                % A��С��thn��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
X(idx) = 1./(1 + exp(-thn)) + (A(idx)-thn)*kn;       % С��thn���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ

% thn��thp֮��Ĳ���
idx    = find(A<=thp & A>=thn);                      
X(idx) = 1./(1 + exp(-A(idx)));                      % sigmoid�������ֵ

% ����thp�Ĳ���
idx    = find(A>thp);  
X(idx) = 1./(1 + exp(-thp)) + (A(idx)-thp)*kp;       % ����thp���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ 


%{
function X = isigmoid(A,nn)

thp = 7;
thn = -7;
kp = 0.01;
kn = 0.01;
X  = A;

idx    = find(A<thn);   
X(idx) = 1./(1 + exp(-A(idx)));

idx    = find(A<=thp & A>=thn);  
X(idx) = 1./(1 + exp(-A(idx)));

idx    = find(A>thp);  
X(idx) = 1./(1 + exp(-A(idx)));
%}

%{
function X = isigmoid(A)

thp = 7;
thn = -7;
kp = 0;
kn = 0;
X  = A;

idx    = find(A<thn);   
X(idx) = 1./(1 + exp(-A(idx)));

idx    = find(A<=thp & A>=thn);  
X(idx) = 1./(1 + exp(-A(idx)));

idx    = find(A>thp);  
X(idx) =  1./(1 + exp(-A(idx))) ;
%}