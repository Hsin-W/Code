% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% �Ӻ�������nnѵ��
% the nn are trained by the programs
function [nn, L]  = nntrain(nn, train_x, train_y, opts, val_x, val_y)


assert(isfloat(train_x), 'train_x must be a float');    % isfloat(train_x)�ж�train_x�ǲ���float���ͣ�assert����������������ʱ�ͻᱨ��
assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')       % ������4������6����������

loss.train.e               = [];          % �⼸��������δ���ã����Ľ����ܺ�ʹ��
loss.train.e_frac          = [];
loss.val.e                 = [];
loss.val.e_frac            = [];
loss_old  = inf;      % loss_old������¼loss �仯���Ա����ѧϰ����

% �ж��Ƿ������֤
opts.validation = 0;        % ���opts.validation = 0�ͱ�ʾ��������֤����
if nargin == 6              % ����Ӻ�������һ�㺯���г�Ϯ��6���������Ǿ���ζi���溬����֤������
    opts.validation = 1;    % �������һ�㺯����������֤���������ͽ�opts.validation = 1 ��ʾ������֤
end

% �ж��Ƿ񻭳����ͼ��
fhandle = [];                                 % ���ÿվ��
if isfield(opts,'plot') && opts.plot == 1     % isfield(S,FIELDNAMES) �����ж�FIELDNAMES�����Ƿ���S����ṹ�����棬  �������˼��Ҫ�������ǰ�趨��plot�������ұ���ֵΪ1�� �Ż�ִ�л�ͼ
    fhandle = figure();                       % ���������ͽ�figure()��ֵ���վ�������ڵ���
end

% ѵ������
numsamples = size(train_x, 1);     % ѵ��������
batchsize  = opts.batchsize;       % С�������ݼ���ģ
numepochs  = opts.numepochs;       % ѭ������
numbatches = numsamples / batchsize;                                 % batch��Ŀ
assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');     % Ҫ�����õ�batchsize�����ܹ������ܵ�ѵ�������� ����Ӧ�ÿ��Ըĳ������������Ȼ��Ѷ����ȥ��

% ��ƿռ������ں��ڴ洢
L = zeros(numepochs*numbatches,1);     % ÿһ��ѵ����ÿһ��batch�����

tracking.loss_train     = [];          % ���ټ�¼ѵ�����仯
tracking.accuracy_train = [];          % ���ټ�¼ѵ�������ʱ仯
tracking.fail_train     = [];          % ֻ��Ҫ�������һ�εĴ���
tracking.thp            = [];
tracking.thn            = [];
for i = 1 : length(val_y)            % ���μ���ÿ��ѵ����
    tracking.loss_val{i}     = [];          % ���ټ�¼��֤���仯
    tracking.accuracy_val{i} = [];          % ���ټ�¼��֤�����ʱ仯
    tracking.fail_val{i}     = [];          % ֻ��Ҫ�������һ�εĴ���
end
tracking.lr = [];             % ��¼ѧϰ����
tracking.time_train = [];     % ��¼ѵ��ʱ�䣬��ÿ��ѭ��ѵ��ʱ������������ ������ͼ��ʱ�䲻�����ȥ

% ��ʽ��ѵ��
for i = 1 : numepochs       % ��ѭ�������ν���ÿһ��ѧϰ
    tic;                    % ��ʱ���
    
    % randbatch = randperm(numsamples);
    randbatch = nn.opts.randbatch;          % nnmain��Ԥ�裬���������ϳ�batch
    for l = 1 : numbatches                  % Сѭ�������μ���batch
        batch_x = train_x(randbatch((l - 1) * batchsize + 1 : l * batchsize), :);     % �ֳ���װ��batch��������ǰ����
        batch_y = train_y(randbatch((l - 1) * batchsize + 1 : l * batchsize), :);
        
        % �ж��Ƿ��������
        %{ 
        %Add noise to input (for use in denoising autoencoder)
        if(nn.inputZeroMaskedFraction ~= 0)
            batch_x = batch_x.*(rand(size(batch_x))>nn.inputZeroMaskedFraction);
        end
        %}
        
        % ���Ĳ���
        nn = nnff(nn, batch_x, batch_y);       % ����nnff��ǰ������
        nn = nnbp(nn,i);                       % ����nnbp��������ڣ�����Ȩֵ��ƫ��ֵ�ĸ�����������ɸ���
        %nn = nnapplygrads(nn);                % ��ɸ��£��ù����ѱ��ںϵ���nnbp�У�
        
        L(end + 1) = nn.loss;                  % ��¼ÿһ��ѭ����ÿһ��batch����������
        
    end
    t = toc;                                   % ��ʱ��ֹ��������ʱʵ����ֻ������ѵ��������nnff��nnbp��ʱ�䣬�����������е�ʱ��ȥ��
    tracking.time_train(end + 1) = t;          % ��ÿһ��ѵ����ʱ�������
    
    % ȷ���Ƿ�������֤
    if opts.validation == 1                    % ����д�����֤���������ͽ�������֤����֤
        tracking = nntracking(nn, tracking, train_x, train_y, val_x, val_y);   % ����û�н���batch
        str_perf = sprintf('; Full-batch train mse = %f, val mse = %f', tracking.accuracy_train(end) , tracking.accuracy_val{1}(end));    % ÿ��ѧϰepoch�����������ؽ�����Թ۲����
    else                                       % ���û����֤����������ֻ����ѵ��������
        tracking = nntracking(nn, tracking, train_x, train_y);                 % ����û�н���batch
        str_perf = sprintf('; Full-batch train mse = %f', tracking.accuracy_train(end));
    end
    
    % ��ͼ����
%     if ishandle(fhandle)   % ishandle�������������ʹͼ�δ��������ͻ᷵��true
%         nnupdatefigures(nn, fhandle, loss, opts, i);
%     end
    
    ave_loss = mean(L((end-numbatches+1):(end)));           % ���㱾��ѭ��������batch��ƽ�������Կ��ǽ���������ֱ�ӻ���tracking�����е����
    disp(['epoch F' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mini-batch mean squared error on training set is ' num2str(ave_loss) str_perf]);
    
    if  tracking.loss_val{1}(end) > loss_old                   % �������ѧϰ����֤��������һ�ε�����ô�ͼ�Сѧϰ���ʣ�loss_old��ʼֵΪinf����˵�һ���ǲ������ѧϰ���ʵ�
        nn.opts.lr   = nn.opts.lr * nn.opts.lr_adjust;      % ִ��ѧϰ���ʸ���  
    end
    loss_old = tracking.loss_val{1}(end);                      % �����ε���֤��ֵ��loss_old������һ�αȽ�
    tracking.lr(end + 1) = nn.opts.lr;                      % ��ÿһ��ѧϰ���ʴ����������ڹ۲�ѧϰ���ʱ仯���
end  

nn.tracking = tracking;                                     % ����nn�ṹ�����崫���Ӻ���

