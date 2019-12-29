% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������itanh_opt�������itanh��������ֵ��С����ֵ֮��Ĳ��ֻ���������ֵ��tanh����Ϊб�ʵ�ֱ�ߣ�
function X = reltanh_opt(A, nn,i)

thp = 0;  % nn.net{i}.thp;       % �����������ֵ
thn = nn.net{i}.thn;     % �����������ֵ

X  = zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ���

% С��thn�Ĳ���
%{
idx    = find(A<thn);                       % A��С��thn��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
t      = tanh(thn);                          % ��ʱ����������thn����tanh����ֵ���Լ���ó���tanh�ĵ���
X(idx) = tanh(thn) + (A(idx)-thn)*(1-t^2);       % С��thn���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ
%}

% thn��thp֮��Ĳ���
idx    = find(A<=thp );         % & A>=thn            
X(idx) = tanh(A(idx));                      % sigmoid�������ֵ

% ����thp�Ĳ���
%{
idx    = find(A>thp);  
t      = tanh(thp);                          % ��ʱ����������thn����tanh����ֵ���Լ���ó���tanh�ĵ���
X(idx) = tanh(thp) + (A(idx)-thp)*(1-t^2);       % ����thp���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ 
%}
idx    = find(A>thp);  
X(idx) = 1;       % ����thp���ֵ�ʵ�����������ֵ��sigmoid�������ֵ + ֱ�߲��ֶ�Ӧ��ֵ 


