% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������nn����������㣬����Ȩֵ��ƫ��ֵ�ĸ�����
%% the Backpropagation process for NN
function nn = nnbp(nn,time)        % time��nnmain�е�ǰѵ������

numlayer      = numel(nn.opts.netsize);     % �������   % ������������ǵ�һ��
sparsityError = 0;                          % ϡ�����
batchsize     = nn.opts.batchsize;          % batch�Ĵ�С

%% ����б����������
%  �����
switch nn.opts.output_function                                         % ���ݲ�ͬ������������ȷ������б�ʵļ��㷽ʽ
    case 'sigmoid'
        nn.net{end}.d = nn.net{end}.out .* (1 - nn.net{end}.out);      % ����б��Ϊ��Ӧ�ĵ���
    case 'tanh'
        nn.net{end}.d   = dev_tanh(nn.net{end}.netin);                   % ����б��Ϊ��Ӧ�ĵ���   
    case {'softmax','softmax_st','linear'}
        nn.net{end}.d = ones(size(nn.net{end}.out));                   % ����б��Ϊ1
    case {'ReLU'}
        nn.net{end}.d = dev_ReLU(nn.net{end}.netin,nn);                   % ����б��Ϊ1   
    case {'LReLU'}
        nn.net{end}.d = dev_LReLU(nn.net{end}.netin,nn);                   % ����б��Ϊ1 
    case {'PReLU'}
        nn = dev_PReLU(nn.net{end}.netin,nn,numlayer);                   % ����б��Ϊ1     
    case 'ELU'
        nn.net{end}.d = dev_ELU(nn.net{end}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���        
    case {'reltanh_opt'}
        nn = dev_reltanh_opt(nn.net{end}.netin,nn,numlayer);                   % ����б��Ϊ1           
    case {'hreltanh_opt'}
        nn = dev_hreltanh_opt(nn.net{end}.netin,nn,numlayer);                   % ����б��Ϊ1    
    case {'swish'}
        nn.net{end}.d = dev_swish(nn.net{end}.netin,nn);                   % ����б��Ϊ1   
    case {'softplus'}
        nn.net{end}.d = dev_softplus(nn.net{end}.netin,nn);                   % ����б��Ϊ1          
    case {'hexpo'}
        nn.net{end}.d = dev_hexpo(nn.net{end}.netin,nn);                   % ����б��Ϊ1            
end
nn.net{end}.dd = nn.net{end}.err .* nn.net{end}.d;                     % ��ʵ��������б�ʼ����У�����

% ������
nn.net{end-1}.err = nn.net{end}.dd * nn.net{end}.w';                   % �����ǰһ��������

% �����ڶ��㵥������
%{
for i = numlayer-1        %  �����ڶ��� 
    nn.net{i}.d = dev_tanh(nn.net{i}.netin);                   % ����б��Ϊ��Ӧ�ĵ���
end
nn.net{i}.dd    = nn.net{i}.err .* nn.net{i}.d;                    % ��ʵ��������б�ʼ����У�����
nn.net{i-1}.err = nn.net{i}.dd * nn.net{i}.w';                     % ����ǰһ��ľ������
%}
for i = (numlayer -1) : -1 : 2                                        % ���μ���ÿ��������
    switch nn.opts.activation_function                                 % ���ݲ�ͬ�Ĵ��ݺ���ȷ��У�������㷽ʽ
        case 'sigmoid'
            nn.net{i}.d = nn.net{i}.out .* (1 - nn.net{i}.out);        % ����б��Ϊ��Ӧ�ĵ�����
        case 'sigmoid_time'
            nn.net{i}.d = dev_sigmoid_time(nn.net{i}.netin , nn);      % ����б��Ϊ��Ӧ�ĵ���
        case 'tanh_opt'
            nn.net{i}.d = dev_tanh_opt(nn.net{i}.netin);               % ����б��Ϊ��Ӧ�ĵ���
        case 'tanh'
            nn.net{i}.d = dev_tanh(nn.net{i}.netin);                   % ����б��Ϊ��Ӧ�ĵ���
        case 'itanh'
            nn.net{i}.d = dev_itanh(nn.net{i}.netin , nn);             % ����б��Ϊ��Ӧ�ĵ���
        case 'itanh_opt'
            nn.net{i}.d = dev_itanh_opt(nn.net{i}.netin , nn);         % ����б��Ϊ��Ӧ�ĵ���            
        case 'isigmoid'
            nn.net{i}.d = dev_isigmoid(nn.net{i}.netin , nn);          % ����б��Ϊ��Ӧ�ĵ���
        case 'isigmoid_opt'
            nn.net{i}.d = dev_isigmoid_opt(nn.net{i}.netin , nn);      % ����б��Ϊ��Ӧ�ĵ���
        case 'hisigmoid'
            nn.net{i}.d = dev_hisigmoid(nn.net{i}.netin , nn);         % ����б��Ϊ��Ӧ�ĵ���
        case 'hisigmoid_opt'
            nn.net{i}.d = dev_hisigmoid_opt(nn.net{i}.netin , nn);     % ����б��Ϊ��Ӧ�ĵ���
        case 'ReLU'
            nn.net{i}.d = dev_ReLU(nn.net{i}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���
        case 'LReLU'
            nn.net{i}.d = dev_LReLU(nn.net{i}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���            
        case 'PReLU'
            nn = dev_PReLU(nn.net{i}.netin, nn ,i);                   % ����б��Ϊ��Ӧ�ĵ���
        case 'ELU'
            nn.net{i}.d = dev_ELU(nn.net{i}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���
        case 'reltanh_opt'
            nn = dev_reltanh_opt(nn.net{i}.netin,nn,i);                   % ����б��Ϊ��Ӧ�ĵ���
        case 'hreltanh_opt'
            nn = dev_hreltanh_opt(nn.net{i}.netin,nn,i);                   % ����б��Ϊ��Ӧ�ĵ���
        case 'swish'
            nn.net{i}.d = dev_swish(nn.net{i}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���  
        case 'softplus'
            nn.net{i}.d = dev_softplus(nn.net{i}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���               
        case 'hexpo'
            nn.net{i}.d = dev_hexpo(nn.net{i}.netin,nn);                   % ����б��Ϊ��Ӧ�ĵ���             
    end
    nn.net{i}.dd    = nn.net{i}.err .* nn.net{i}.d;                    % ��ʵ��������б�ʼ����У�����
    nn.net{i-1}.err = nn.net{i}.dd * nn.net{i}.w';                     % ����ǰһ��ľ������
end

%% Ȩֵ��ƫ��ֵ������
for i = numlayer : -1 : 2                                     % �������μ���ÿһ�㣬ֻ�������ڶ��㣬��Ϊ��һ���Ǹ�װ�Σ�Ȩֵ��ƫ��ֵ����0����������
    % ����ֵ
    nn.net{i}.ddw = nn.net{i}.in' * nn.net{i}.dd;             % ����ֵ��У���������Ȩֵ������   % ��һ��������ͬһ��batch�У�����Ȩֵ��ӣ���˺���Ҫ�����batchsize����ƽ��
    nn.net{i}.ddc = nn.net{i}.dd;                             % ƫ��ֵ��������ֻУ�����
    
    % ����ѧϰ����
    nn.net{i}.dddw = nn.opts.lr * nn.net{i}.ddw;              % ����ѧϰ����
    nn.net{i}.dddc = nn.opts.lr * nn.net{i}.ddc;
    
    % ƽ������ֵ
    nn.net{i}.ddddw = nn.net{i}.dddw  / batchsize;             % ����Ȩֵ��������ƽ��ֵ
    nn.net{i}.ddddc = sum(nn.net{i}.dddc ,1) / batchsize;     % ƫ��ֵ��ƽ��ֵ���˴�sum(nn.net{i}.dddc ,1)��batch�е�����sanple����õ���ƫ��ֵ������������ͣ������ƽ��ֵ����Ϊƫ��ֵ������������Ȩֵ�Ǿ���
    
    % ���϶�����
    if time == 1                % ����ǵ�һ��ѵ�����Ͳ�ʹ�ö������Ϊ��������һ�εĸ���ֵ
        nn.net{i}.dddddw = nn.net{i}.ddddw + nn.opts.momentum * 0;        % ��Ϊ������ǰһ�ε������������*0
        nn.net{i}.dddddc = nn.net{i}.ddddc + nn.opts.momentum * 0;
    else                     
        nn.net{i}.dddddw = nn.net{i}.ddddw + nn.opts.momentum * nn.net{i}.dddddw;       % ��ֵ����ұߵ�nn.net{i}.dddddw��ǰһ�εĸ�����  
        nn.net{i}.dddddc = nn.net{i}.ddddc + nn.opts.momentum * nn.net{i}.dddddc;
    end
    
    % ��ֵ����
    nn.net{i}.w = nn.net{i}.w + nn.net{i}.dddddw;
    nn.net{i}.c = nn.net{i}.c + nn.net{i}.dddddc;
end





