% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% �Ӻ�����������SAE����
function sae = saesetup(sae,rand_initial,hyperpara)
netsize = sae.opts.netsize;        % ����Ĳ�����ÿ��Ľڵ���
num_ae  = length(netsize)-2;       % SAE����

% �����Ա�����
for i = 1 : num_ae        % ���μ���ÿ��
    netsize_ae   = [netsize(i) netsize(i+1) netsize(i)];    % ��ae�Ľṹ
    sae.ae{i} = nnsetup(netsize_ae,rand_initial{i},hyperpara);        % ����nnsetup�����Ա�����
    sae.ae{i}.opts.netsize   = netsize_ae;                  % ��ae�Ľṹ
    sae.ae{i}.opts.numepochs = sae.opts.numepochs;          % RBMԤѵ��ѭ������
    sae.ae{i}.opts.batchsize = sae.opts.batchsize;          % ����RBMԤѵ����batch�Ĵ�С
    sae.ae{i}.opts.lr        = sae.opts.lr;                 % ����RBMԤѵ���ĳ�ʼѧϰ����
    sae.ae{i}.opts.lr_adjust = sae.opts.lr_adjust;          % ����RBMԤѵ����ѧϰ���ʵ�������
    sae.ae{i}.opts.momentum  = sae.opts.momentum;           % ����RBMԤѵ���Ķ�����
    sae.ae{i}.opts.randbatch = sae.opts.randbatch;          % ����saetrain�е�batch�����ѡ�� 
    
    sae.ae{i}.opts.output_function      = sae.opts.output_function;           % ����sae���綥�������
    sae.ae{i}.opts.activation_function  = sae.opts.activation_function;           % ����sae����Ĵ��ݺ��� 
end


% ����classifier
dim         = [netsize(end-1),netsize(end)];      % ����ṹ
temp        = sqrt( 3 / dim(1));
temp        = sqrt( 6 /(dim(1) + dim(2)));
sae.classifier.w = 2*(rand_initial{end}(1:dim(1),1:dim(2))- 0.5) * temp *2;  % ;
sae.classifier.c = zeros(1,dim(2));                % ƫ��ֵ��ʼ��Ϊ0








