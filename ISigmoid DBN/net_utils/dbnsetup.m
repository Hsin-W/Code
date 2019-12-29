% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% �Ӻ�������DBN����ṹ����
% the DBN are built as following
function dbn = dbnsetup(dbn,rand_initial)
netsize = dbn.opts.netsize;    % ����Ĳ�����ÿ��Ľڵ���
num_rbm = length(netsize)-2;   % RBM�ĸ���
dbn.rbm = cell(num_rbm,1);     % �����洢ÿ��RBM������ݵ�Ԫ������

% ����RBM
for i= 1:num_rbm    % ���μ���ÿ��RBM
    %{
    dim = [netsize(i),netsize(i+1)];     % ��ǰRBM��ά��
    r   = 4*sqrt(6./(dim(1)+dim(2)));    % һ������������㷺��������ʼ�����RBM��Ȩֵ
    
    dbn.rbm{i}.w  = 2*r*rand(dim(1),dim(2))-r;      % ��ǰRBN��Ȩֵ����
    dbn.rbm{i}.b  = zeros(1,dim(1));                % ��ǰRBM������ƫ��ֵ����
    dbn.rbm{i}.c  = zeros(1,dim(2));
    dbn.rbm{i}.vw = zeros(size(dbn.rbm{i}.w));      % �����洢Ȩֵ��ƫ��ֵ�ĸ���ֵ
    dbn.rbm{i}.vb = zeros(size(dbn.rbm{i}.b));
    dbn.rbm{i}.vc = zeros(size(dbn.rbm{i}.c));
    %}
    
    dim         = [netsize(i),netsize(i+1)];      % ����ṹ
    temp        = sqrt( 3 / dim(1));
    %temp        = sqrt( 6 /(dim(1) + dim(2)));
    dbn.rbm{i}.w = 2*(rand_initial{i}(1:dim(1),1:dim(2))- 0.5) * temp;  % ;    
    dbn.rbm{i}.b  = zeros(1,dim(1));                % ��ǰRBM������ƫ��ֵ����
    dbn.rbm{i}.c  = zeros(1,dim(2));
    dbn.rbm{i}.vw = zeros(size(dbn.rbm{i}.w));      % �����洢Ȩֵ��ƫ��ֵ�ĸ���ֵ
    dbn.rbm{i}.vb = zeros(size(dbn.rbm{i}.b));
    dbn.rbm{i}.vc = zeros(size(dbn.rbm{i}.c));    
    
end

% ����classifier
%{
r=4*sqrt(6./(netsize(end-1)+netsize(end)));                     % �����������r�������
dbn.classifier.w = 2*r*rand(netsize(end-1),netsize(end))-r;     % �����������Ȩֵ����
dbn.classifier.c = zeros(1,netsize(end));                       % �����������ƫ��ֵ����
%}
dim         = [netsize(end-1),netsize(end)];      % ����ṹ
temp        = sqrt( 3 / dim(1));
%temp        = sqrt( 6 /(dim(1) + dim(2)));
dbn.classifier.w = 2*(rand_initial{end}(1:dim(1),1:dim(2))- 0.5) * temp;  % ;
dbn.classifier.c = zeros(1,dim(2));                % ƫ��ֵ��ʼ��Ϊ0


