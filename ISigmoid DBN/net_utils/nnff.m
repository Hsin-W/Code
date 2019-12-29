% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% �Ӻ�������ǰ������
% the feedfward process of NN
function nn = nnff(nn, x, y)                % ���ø�ʽ�� nn = nnff(nn, batch_x, batch_y);

    numlayer  = numel(nn.opts.netsize);     % �������
    numsample = size(x, 1);                 % ����������һ��batch��������
    
    
    % �����ǰ��
    nn.net{1}.in    = x;                    % �����һ������ֵ��������ֵ���ֵ����x��ʵ����û�ж������м���
    nn.net{1}.netin = x;
    nn.net{1}.out   = x;                    % ����������ֱ�Ӵ��ݸ���һ����Ϊ���ʼ����

    % ������ǰ��
    for i = 2 : numlayer-1        %  �ӵڶ��㿪ʼ���漰�����ݺ����仯�������Ƿ�������˲����������
        
        nn.net{i}.in    = nn.net{i-1}.out;     % ���������ֵ����һ������ֵ
        nn.net{i}.netin = nn.net{i}.in * nn.net{i}.w + repmat(nn.net{i}.c , numsample ,1);        % ���㾻����ֵ 
        
        switch nn.opts.activation_function                            % �жϲ�ͬ�Ĵ��ݺ���
            case 'sigmoid'                                            % ��ͨ��sigmoid��
                nn.net{i}.out = sigmoid(nn.net{i}.netin);             % �����൱����sigm��net+b��
            case 'sigmoid_time'                                       % ��ͨsigmoid�Ĺ��ܣ���isigmoid��hisigmoid����ͬ�ĳ���ṹ�����ڱȽ�ʱ���޳���Ϊ����д�����µ�ʱ�����
                nn.net{i}.out = sigmoid_time(nn.net{i}.netin , nn);
            case 'tanh_opt'                                           % �Ż���tanh����ͨ��tanh�����[-1,1],tanh_opt��[0,1]
                nn.net{i}.out = tanh_opt(nn.net{i}.netin);            
            case 'tanh'                                               % ��ͨ��tanh     
                nn.net{i}.out = tanh(nn.net{i}.netin);                % tanh��ϵͳ��������ֱ�ӵ���
            case 'itanh'                                              % itanh     
                nn.net{i}.out = itanh(nn.net{i}.netin , nn);               % tanh��ϵͳ��������ֱ�ӵ���   
            case 'itanh_opt'                                              % itanh     
                nn.net{i}.out = itanh_opt(nn.net{i}.netin , nn);               % tanh��ϵͳ��������ֱ�ӵ���                     
            case 'isigmoid'                                           % ��sigmoid�����˵��ض���ֵ��ĺ����ĳ���ֱ�ߣ�ֱ�ߵ�б����Ԥ���
                nn.net{i}.out = isigmoid(nn.net{i}.netin, nn); 
            case 'isigmoid_opt'                                       % ��sigmoid�����˵��ض���ֵ��ĺ����ĳ���ֱ�ߣ�ֱ��б����sigmoid����ֵ���ĵ���
                nn.net{i}.out = isigmoid_opt(nn.net{i}.netin, nn); 
            case 'hisigmoid'                                          % ��߼����isigmoid��Ҳ���Ǹ�������Ϊ��ͨsigmoid�������������������ֵ��Ĳ��ָ�Ϊֱ�ߣ�ֱ��б����Ԥ���
                nn.net{i}.out = hisigmoid(nn.net{i}.netin, nn);  
            case 'hisigmoid_opt'                                      % ��߼����isigmoid��Ҳ���Ǹ�������Ϊ��ͨsigmoid�������������������ֵ��Ĳ��ָ�Ϊֱ�ߣ�ֱ��б����sigmoid����ֵ���ĵ���
                nn.net{i}.out = hisigmoid_opt(nn.net{i}.netin, nn); 
            case 'ReLU'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = ReLU(nn.net{i}.netin,nn);
            case 'LReLU'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = LReLU(nn.net{i}.netin,nn);
            case 'PReLU'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = PReLU(nn.net{i}.netin,nn,i);                  
            case 'ELU'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = ELU(nn.net{i}.netin,nn);          
            case 'reltanh_opt'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = reltanh_opt(nn.net{i}.netin,nn,i);  
            case 'hreltanh_opt'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = hreltanh_opt(nn.net{i}.netin,nn,i);         
            case 'swish'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = swish(nn.net{i}.netin,nn);     
            case 'softplus'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = softplus(nn.net{i}.netin,nn);                   
            case 'hexpo'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
                nn.net{i}.out = hexpo(nn.net{i}.netin,nn);                         
        end
%{       
        %dropout
        if(nn.dropoutFraction > 0)
            if(nn.testing)
                nn.a{i} = nn.a{i}.*(1 - nn.dropoutFraction);
            else
                nn.dropOutMask{i} = (rand(size(nn.a{i}))>nn.dropoutFraction);
                nn.a{i} = nn.a{i}.*nn.dropOutMask{i};
            end
        end
        
        %calculate running exponential activations for use with sparsity
        if(nn.nonSparsityPenalty>0)
            nn.p{i} = 0.99 * nn.p{i} + 0.01 * mean(nn.a{i}, 1);
        end
        
        %Add the bias term
        nn.a{i} = [ones(num_samples,1) nn.a{i}];    % ����ƫ��ֵ���У���������һ����ʹ��
        nn.netinput{i} = [ones(num_samples,1) nn.netinput{i}];
 %}
    end
%% �����ڶ��㵥������
%{
    for i = numlayer-1        %  �����ڶ��� 
        nn.net{i}.in    = nn.net{i-1}.out;     % ���������ֵ����һ������ֵ
        nn.net{i}.netin = nn.net{i}.in * nn.net{i}.w + repmat(nn.net{i}.c , numsample ,1);        % ���㾻����ֵ 
        nn.net{i}.out = tanh(nn.net{i}.netin);                % tanh��ϵͳ��������ֱ�ӵ���
    end
%}
%%     
    % �����ǰ��
    nn.net{end}.in    = nn.net{end - 1}.out;      % ����ֵ��ǰһ������ֵ
    nn.net{end}.netin = nn.net{end}.in * nn.net{end}.w + repmat(nn.net{end}.c , numsample ,1);      % ������ֵ
  
    switch nn.opts.output_function                             % ���ݲ�ͬ��������������ȷ�����ֵ���㷽ʽ
        case 'sigmoid'                                         % sigmoid������
            nn.net{end}.out = sigmoid(nn.net{end}.netin);
        case 'tanh'                                         % sigmoid������
            nn.net{end}.out = tanh(nn.net{end}.netin);    
        case 'linear'                                          % ���Է�����
            nn.net{end}.out = nn.net{end}.netin;
        case 'ReLU'                                          % ���Է�����
            nn.net{end}.out = ReLU(nn.net{end}.netin,nn);
        case 'LReLU'                                          % ���Է�����
            nn.net{end}.out = LReLU(nn.net{end}.netin,nn);
        case 'PReLU'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
            nn.net{end}.out = PReLU(nn.net{end}.netin,nn,i+1);      
        case 'ELU'                                               % �˴���ReLUʵ������LReLU��������������һ����С��б��
            nn.net{end}.out = ELU(nn.net{end}.netin,nn);                    
        case 'reltanh_opt'                                          % ���Է�����
            nn.net{end}.out = reltanh_opt(nn.net{end}.netin,nn,i+1);
        case 'hreltanh_opt'                                          % ���Է�����
            nn.net{end}.out = hreltanh_opt(nn.net{end}.netin,nn,i+1);        
        case 'swish'                                          % ���Է�����
            nn.net{end}.out = swish(nn.net{end}.netin,nn);          
        case 'softplus'                                          % ���Է�����
            nn.net{end}.out = softplus(nn.net{end}.netin,nn);                   
        case 'hexpo'                                          % ���Է�����
            nn.net{end}.out = hexpo(nn.net{end}.netin,nn);                            
        case 'softmax'                                         % softmax��������MATLAB��������ʽ
            temp = exp(bsxfun(@minus, nn.net{end}.netin, max(nn.net{end}.netin,[],2)));      % max(nn.a{n},[],2)�ҳ�ÿһ�е����ֵ     
            nn.net{end}.out = bsxfun(@rdivide, temp, sum(temp, 2)); 
        case 'softmax_st'                                      % softmax_st���������Լ�������ʽ��softmax(n)=exp(n)/sum(exp(n))   
            temp = exp(nn.net{end}.netin);
            nn.net{end}.out = bsxfun(@rdivide, temp, sum(temp, 2));     % ��sum(y,2)����size(y,2��
      
    end

    % ��ʵ������������
    nn.net{end}.err = y - nn.net{end}.out;           % ��ʵ������nnff�м��������
    switch nn.opts.output_function
        case {'sigmoid','tanh', 'linear','PReLU','ReLU','LReLU','reltanh_opt','hreltanh_opt','ELU','hexpo','softplus'}
            nn.loss = 1/2 * sum(sum(nn.net{end}.err .^ 2)) / numsample;     % numsample�����batch�е�������
        case 'softmax'
            nn.loss = -sum(sum(y .* log(nn.net{end}.out))) / numsample;     % δ֪
        case 'softmax_st'
            nn.loss = -sum(sum(y .* log(nn.net{end}.out))) / numsample;
        otherwise
            nn.loss = 1/2 * sum(sum(nn.net{end}.err .^ 2)) / numsample;     % numsample�����batch�е�������
    end

