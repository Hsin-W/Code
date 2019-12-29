% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ�������RBMԤѵ��
function rbm = rbmtrain(rbm, x, opts)

assert(isfloat(x), 'x must be a float');          % ��������x����float���ͣ��ͱ���
%assert(all(x(:)>=0) && all(x(:)<=1), 'all data in x must be in [0:1]');           % ���xû����ɹ�һ�����ͱ���
numsamples = size(x, 1);                                       % �����������
numbatches = numsamples / opts.batchsize;                      % batch����Ŀ
assert(rem(numbatches, 1) == 0, 'numbatches not integer');     % ���batch����Ŀ�����������ͱ���
errold = inf;        % Ԥ��errold�����ںͱ��ε�err�Ƚϣ��Ա����ѧϰ����

% ��ʽѧϰ
for i = 1 : opts.numepochs            % ����ѵ��         
    %kk = randperm(numsamples);
    randbatch = opts.randbatch;       % ��nnmain��Ԥ�裬����batch�����ѡ��
    errsum = 0;                       % Ԥ�����ͣ���ѭ�����õ�
    for l = 1 : numbatches            % ���μ���ÿ��batch
        batch = x(randbatch((l - 1) * opts.batchsize + 1 : l * opts.batchsize), :);   % ��ʱ����batch����ʱ��������㣬����һ��������ɾͱ�֤��batch����仯�ˣ���Ȼ��ʹ��ѵ�����߲��ۺܴ�
        
        % ���һ��CD
        V1_d2v = batch;                                                               % ��һ�οɼ��㵽������
        H1_v2h = sigmrnd(V1_d2v * rbm.w + repmat(rbm.c , opts.batchsize, 1));         % ��һ�������㷵�ؿɼ���
        V2_h2v = sigmoid(H1_v2h * rbm.w'+ repmat(rbm.b , opts.batchsize, 1));         % �ڶ��οɼ��㵽������
        H2_v2h = sigmoid(V2_h2v * rbm.w + repmat(rbm.c , opts.batchsize, 1));         % �ڶ��������㷵�ؿɼ���

        % ÿ��batch�Ĳ���������
        dw_batch = V1_d2v'*H1_v2h - V2_h2v'*H2_v2h;        % ����Ȩֵ��ƫ��ֵ����ֵ
        db_batch = sum(V1_d2v) - sum(V2_h2v);
        dc_batch = sum(H1_v2h) - sum(H2_v2h);
        % ÿ�������Ĳ���������
        dw_sample = dw_batch / opts.batchsize;             % ��������ֵ��ƽ��ֵ
        db_sample = db_batch / opts.batchsize;
        dc_sample = dc_batch / opts.batchsize;            
        % ��������          
        rbm.vw = opts.momentum * rbm.vw + opts.lr * dw_sample;     % ���붯������ѧϰ���ʵĴ���
        rbm.vb = opts.momentum * rbm.vb + opts.lr * db_sample;
        rbm.vc = opts.momentum * rbm.vc + opts.lr * dc_sample;

        rbm.w = rbm.w + rbm.vw;      % ��ֵ��Ч
        rbm.b = rbm.b + rbm.vb;
        rbm.c = rbm.c + rbm.vc;

        err = sum(sum((V1_d2v - V2_h2v).^2)) / opts.batchsize;       % �����ع����
        errsum = errsum + err;                 % �ۼƱ���ѧϰ������batch���ع�����
    end

    rbm.recon_err(i) = errsum / numbatches;   % ���㱾��ѧϰ������batch���͵�ƽ��ֵ 
    if i>=2       % ������ǵ�һ��ѧϰ����Ҫ�Ƚϱ��κ�ǰһ�ε��ع����Ѿ����Ƿ����ѧϰ����
        if rbm.recon_err(i) > rbm.recon_err(i-1)  
           opts.lr = opts.lr_adjust * opts.lr;
        end
    end

    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)  '. Average reconstruction error is: ' num2str(rbm.recon_err(i))]);      % �����ǰ�ǵڼ���ѧϰ���Լ���ǰ���ع����

end

