% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% the derivative of PReLU
function  nn = dev_PReLU(A,nn,i)

% ����ѧϰ



X=zeros(size(A));       % ��Aͬ��size�ľ������ڴ洢����õ��ľ��� 

% ���ڵ���0�Ĳ���
idx    = find(A>=0);    % A�д���0��Ԫ�ص����꣨�����갴�մ��ϵ��£������ҵ�˳�����μ�����
nn.net{i}.k_PReLU= nn.net{i}.k_PReLU + 0;    % K_PReLU����
X(idx) = 1;             % ����һ����ֱ�ӽ�������ֵΪ1

%% С��0�Ĳ���

% ͬ�㹲��k_PReLU
% {
idx    = find(A<0);
temp = zeros(size(A));
temp(idx) = A(idx) ;
nn.net{i}.k_PReLU = nn.net{i}.k_PReLU - nn.opts.lr * mean(mean(temp .* (nn.net{i}.err))) ; 
X(idx) = nn.net{i}.k_PReLU;

nn.net{i}.d = X;
%}


% ÿ���ڵ��k_PReLU��ͬ
%{
[row,col,val]    = find(A<0);     % �Ծ�����ֵС��0���ⲿ�֣����䵽����ֱ�Ӹ�ֵΪ0.01
ttt = zeros(size(A));
ttt(row,col) = A(row,col);
nn.net{i}.k_PReLU = nn.net{i}.k_PReLU + 0.01 * mean(ttt,1) ;
k = nn.net{i}.k_PReLU; 
temp = repmat(k,size(A,1),1);
X(row,col) = temp(row,col) ;
%}


