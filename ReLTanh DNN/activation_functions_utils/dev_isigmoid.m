% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������isigmoid�ĵ���
function X = dev_isigmoid(A,nn)

thp = nn.opts.th_god;      % �����������ֵ
thn = -nn.opts.th_god;     % �����������ֵ
kp  = nn.opts.k_god;       % ���������б��
kn  = nn.opts.k_god;       % ���������б��
X  = zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ���

% С��thn�Ĳ���
idx    = find(A<thn);       % A��С��thn��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
X(idx) = kn;                % С��thn�Ĳ��֣���Ԥ���kp��Ϊ����

% thn��thp֮��Ĳ���
idx    = find(A<=thp & A>=thn);   % thn��thp֮��Ĳ��ְ�������sigmoid���㵼��
t(idx) = 1./(1 + exp(-A(idx)));
X(idx) = t(idx).*(1- t(idx));

% ����thp�Ĳ���
idx    = find(A>thp);        % ����thp�Ĳ��֣���Ԥ���kp��Ϊ����
X(idx) = kp;               


%}

%{
function X = dev_isigmoid(A,nn)

th = 7;
kp = 0.01;
kn = 0.01;
X  = zeros(size(A));

idx    = find(A<-th);   
X(idx) = A(idx).*(1- A(idx));

idx    = find(abs(A)<=th);  
X(idx) = A(idx).*(1- A(idx));

idx    = find(A>th);  
X(idx) = A(idx).*(1- A(idx));
%}

%{
function X = dev_isigmoid(A)

th = 7;
kp = 0.01;
kn = 0.01;
X  = zeros(size(A));

idx    = find(A<-th);   
X(idx) = A(idx).*(1- A(idx));

idx    = find(abs(A)<=th);  
X(idx) = A(idx).*(1- A(idx));

idx    = find(A>th);  
X(idx) = A(idx).*(1- A(idx));
%}