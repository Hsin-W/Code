% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�����������nn���磨���ѡ������������BPNN����ֱ���ô˺����������磩
% the NN net are constructed as follows
function nn = nnsetup(netsize,rand_initial,hyperpara)      % ���ø�ʽΪ��nn = nnsetup([784 20 10]);    

% �������
nn.size   = netsize;          % ����ṹ
nn.n      = numel(nn.size);   % �õ�����Ĳ���

nn.opts.activation_function              = 'NULL';   %  ���ݺ���
nn.opts.lr                               = 1;         %  ��ʼѧϰ����
nn.opts.momentum                         = 0;            %  ������
nn.opts.lr_adjust                        = 0.95;         %  ѧϰ���ʵ�������
nn.opts.weightPenaltyL2                  = 0;            %  Ȩֵ�ͷ���������
nn.opts.nonSparsityPenalty               = 0;            %  ϡ��ͷ�
nn.opts.sparsityTarget                   = 0;            %  Sparsity target
nn.opts.inputZeroMaskedFraction          = 0;            %  Used for Denoising AutoEncoders
nn.opts.dropoutFraction                  = 0;            %  Dropout level (http://www.cs.toronto.edu/~hinton/absps/dropout.pdf)
nn.opts.testing                          = 0;            %  Internal variable. nntest sets this to one.
nn.opts.output_function                  = 'NULL';    %  ����������

% ��ʼ
nn.net{1}.w = [0];         % ����� 
nn.net{1}.c = [0];

for i = 2 : nn.n % �������������

    % xaviar��һ��
    % {
    dim         = [netsize(i-1),netsize(i)];      % ����ṹ
    temp        = sqrt( 3 / dim(1));
    temp        = sqrt( 6 /(dim(1) + dim(2)));
    nn.net{i}.w = 2*(rand_initial(1:dim(1),1:dim(2))- 0.5) * temp;  % ;
    nn.net{i}.c = zeros(1,dim(2));                 % ƫ��ֵ��ʼ��Ϊ0
    %}
     
    nn.net{i}.k_PReLU = hyperpara.k_PReLU ;  %*ones(1,dim(2)) ;
    nn.net{i}.thp = hyperpara.thp ;          %*ones(1,dim(2)) ;
    nn.net{i}.thn = hyperpara.thn;           %*ones(1,dim(2)) ;
     
end

