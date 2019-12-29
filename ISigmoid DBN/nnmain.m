% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% main function

%% �Ӻ������������л�
% ���޸�Ϊ�Ӻ���������godfinger����
function nn = nnmain(acfun,i_rep, flag,i_acfun,nettype, lr_god, filename)          % �Ƚϲ�ͬ�����            

%% setup before training
scalerpool = {'minmax','maxabs','z-score'};
scaler = scalerpool{3};
prelr  = 0.005;                 % lr for pretrain
premom = 0.005;                 % momentum for pretrain
prelr_adjust = 0.99;            % lr can be adjusted by prelr_adjust
lr     = lr_god;                 % lr for train
mom    = lr_god;
lr_adjust = 0.99;

% default parameters
if ~exist('flag','var')||isempty(flag)        flag = 'acfuns';   end       % if get no or empty flag, flag is set as 'acfuns' for default��
if ~exist('acfun','var')||isempty(acfun)      acfun = 'sigmoid'; end       % ditto��
if ~exist('nettype','var')||isempty(nettype)  nettype = 'DBN';   end       % ditto��
if ~exist('i_acfun','var')||isempty(i_acfun)  i_acfun = 1;       end       % ditto��
if ~exist('i_rep','var')||isempty(i_rep)      i_rep = 0;         end       % ditto��




%% �����Ȩ����  random numbers are carete and load for initialization of weights and biases
% {  
for i = 1: 2500   rands{i} = randperm(i*10);         end     % ��������ѡ����minibatch
for i = 1: 20     rand_initial{i} = rand(100,100);   end     % ����ÿһ��Ȩֵ��ʼ


% {
%% load and slice up 
%%%%%%%%%% planetary gearbox data %%%%%%%%%%%%%
load ('gear_fault_featuredata_5120','featuredata');           % ���ع�������   the dataset are loaded 
N      = 4000;                                                % the number of samples
randt  = rands{N/10};
dim    = [1:50];                                              % ����ѡ��   only the 
data   = double(featuredata.feature(randt(1:N),dim));               
label  = data_binarize(featuredata.labelload(randt(1:N),1)-1);  % ��ǩ��ֵ����������1��ԭ����binarize�����ڲ���һ�����mnist�ļ�1����
load1  = featuredata.labelload(randt(1:N),2);                   % ��ȡ��������


%% ѡ��ѵ�����ݼ�����֤���ݼ���η���  training and testing samples 
% {
N  = size(label,1);              % number of samples
Nt = 2000;                       % number of samples for trianing
Nv = 250;                        % number of samples for validation
tx0 = data(1:Nt,:);              % ѵ������  the training samples
ty  = label(1:Nt,:);             % ѵ��������Ӧ�ı�ǩ   the labels for the training samples
[tx,para1,para2]  =  data_normalize(tx0,scaler) ; % ѵ������һ�� ��para1,para2���ڹ�һ�����Լ�   normalize the samples
randbatch_temp = rands{Nt/10};   %  the minibatch are created according this random matrix 

% 22 testing datasets are created
for i = 1:8
    vx{i}   = data(Nt+1+(i-1)*Nv:Nt+i*Nv,:);                        % ��֤����   the testing sample 
    [vx{i}, mu, sigma] = data_normalize(vx{i},scaler,para1,para2);  % ���Լ���һ����ʹ��ѵ�����Ĳ���   the testing samples are normalized 
    vx{i}   = vx{i}(1:Nv,:);                                        
    vy{i}   = label(Nt+1+(i-1)*Nv:Nt+i*Nv,:);                       % ��֤������Ӧ�ı�ǩ
end
% {
Nt = 2100;
for i = 9:15
    vx{i}   = data(Nt+1+(i-1-8)*Nv:Nt+(i-8)*Nv,:);                  % ��֤����
    [vx{i}, mu, sigma] = data_normalize(vx{i},scaler,para1,para2);  % ���Լ���һ����ʹ��ѵ�����Ĳ���
    vx{i}   = vx{i}(1:Nv,:);
    vy{i}   = label(Nt+1+(i-1-8)*Nv:Nt+(i-8)*Nv,:);                 % ��֤������Ӧ�ı�ǩ
end
Nt = 2200;
for i = 16:22
    vx{i}   = data(Nt+1+(i-1-15)*Nv:Nt+(i-15)*Nv,:);                % ��֤����
    [vx{i}, mu, sigma] = data_normalize(vx{i},scaler,para1,para2);  % ���Լ���һ����ʹ��ѵ�����Ĳ���
    vx{i}   = vx{i}(1:Nv,:);
    vy{i}   = label(Nt+1+(i-1-15)*Nv:Nt+(i-15)*Nv,:);               % ��֤������Ӧ�ı�ǩ
end


%% ����������� the parameters of the networks
num_innode  = size(data,2);      % �����Ľڵ�������������ά��     
num_outnode = size(label,2);     % �����Ľڵ���������������������Ҳ�Ƕ�ֵ����ı�ǩ��ά��
netsize = [num_innode 39 33 27 21 15 9 num_outnode];         % ���ڳ��ֹ�������    50 32 22 12 5 ��  45 40 35 30 25 20 15 10 �� 11 9 7 5  �� 12 9 7 5   38 32 25 18 12


hyperpara.k_PReLU = 0.2;            % hyperparameter for PReLU only
hyperpara.thp = 0                   %th_god(i_th) % th_god(i_th);
hyperpara.thn = -1.5                %-th_god(i_th) %-th_god(i_th);
% the below params for pretraining
switch nettype                                            % �����ں��������ѡ����������ͽ���ѡ��  the nettype are set in godfinger
    case 'DBN'   % DBN design and pretraining
        dbn.opts.netsize   = netsize;                     % DBN������ṹ the netsize of the BDN    
        dbn.opts.randbatch = randbatch_temp;              % ������ʱ����������� the minibatch are created according this random matrix
        dbn.opts.numepochs = 5;                          % RBMԤѵ��ѭ������  the number of epoches for pretraining 
        dbn.opts.batchsize = 25;                          % ����RBMԤѵ����batch�Ĵ�С the bachsize for pretraining 
        dbn.opts.lr        = prelr;                       % ����RBMԤѵ���ĳ�ʼѧϰ����  the lr for pretraining 
        dbn.opts.lr_adjust = prelr_adjust                 % ����RBMԤѵ����ѧϰ���ʵ�������  the lr are adjusted by this paramete during pretraining process
        dbn.opts.momentum  = premom;                      % ����RBMԤѵ���Ķ�����  the momentum during pretraining process
        
        dbn  = dbnsetup(dbn,rand_initial);                % �����Ӻ�������DBN����  several RBMs are built for DBN 
        dbn  = dbntrain(dbn,tx);                          % Ԥѵ��RBM  the RBMs are pretrained 
        nn   = nnassemble_dbn(dbn,hyperpara);             % �����Ӻ�������Ԥѵ���õ���Ȩֵ��ƫ��ֵ������װ��һ��nn����    the trained RBMs are taken to bulit a complete DBN 
end
% the blow params are designed for BP process
nn.opts.netsize              = netsize;   
nn.opts.randbatch            = randbatch_temp;            % ������ʱ�����������     the minibatch are created according this random matrix
nn.opts.lr                   = lr;                        % ����nn����ĳ�ʼѧϰ����  the lr for BP training 
nn.opts.lr_adjust            = lr_adjust;                 % ����nn�����ѧϰ���ʵ�������  the lr are adjusted by this paramete during BP process
nn.opts.momentum             = mom;                       % ����nn����Ķ�����   the momentum during BP process
nn.opts.output_function      = 'softmax';                 % ����nn���綥�������   the classifier function for the pretraining of DNN
nn.opts.activation_function  = acfun;                     % ����nn����Ĵ��ݺ���  the activation function for the pretraining of DNN
nn.opts.numepochs            = 500;                         % nnѵ��ѭ������   the number of epoches for pretraining 
nn.opts.batchsize            = 25;                        % nn��batch��С   the bachsize for pretraining 
nn.opts.plot                 = 0;                         % �Ƿ�ͼ���ǣ�1����0    do you want to get the curves of training accuracy, etc. 


nn.opts.k_god  = 0.2;    % the preseted k and th for ISigmoid only
nn.opts.th_god = 4; 
nn = nntrain(nn, tx, ty, nn.opts, vx, vy);     % �����Ӻ���ѵ��nn     nntrain are called for BP process



%% print and save
% the title and path for the plot and result excel
address_1th = strcat(filename,'\');
switch flag            % ���ݲ�ͬ��flagȷ������ĵ�ַ��
    case 'acfuns'      % nnmain��Ϊ�Ӻ������Ƚϲ�ͬ�Ĵ��ݺ���
        subtitle    = strcat(flag , ' ' , ' (' , nn.opts.activation_function , ')' );     % ͼ�θ��������ã�����˵����ͼ��ͨ��ʲô���ݺ�����th&k�õ���
        address_2th = strcat(address_1th, subtitle );          % ���ͼƬ�����ַ
    case 'th&k'        % nnmain��Ϊ�Ӻ������Ƚϲ�ͬ��th&k
        subtitle    = strcat(flag , ' ' ,  ' (' , num2str(th_god(i_th)*100) , '&' , num2str(k_god(j_th)*100) , ' )' ); 
        %subtitle    = strcat(flag , ' ' ,  ' (' , num2str(k_god(i_k)*100) , '&' , num2str(1) , ' )' );   % ֻ���ReLUs
        address_2th = strcat(address_1th, subtitle );          % ���ͼƬ�����ַ
        %address_2th = strcat(address_1th, subtitle ,',k=',num2str(nn.opts.k_god));

end
mkdir(address_2th);       % �����ṩ�ĵ�ַ�Ƚ���һ����Ŀ¼   create a file to store the result



%   the curves are created and saved
% {
fprintf('ploting now .... \n');
nnfigure(nn.tracking.accuracy_train , address_2th , strcat('training accuracy rate ~~ ',subtitle ) , 'epoch' , 'Classification rate');      % ѵ����ȷ������
nnfigure(nn.tracking.loss_train     , address_2th , strcat('training error ~~ ',subtitle ) ,  'epoch' , 'Error');                           % ѵ���������
nnfigure(nn.tracking.lr             , address_2th , strcat('learningrate ~~ ',subtitle )   , 'epoch' , 'LearningRate');                     % �������ѧϰ��������
if strcmp(acfun,'hreltanh_opt')    % the hyperparams thp and thn are ploted for hreltanh_opt only
    for i = 1: length(nn.net)-2
        nnfigure([nn.tracking.thp(i,:);nn.tracking.thn(i,:)]       , address_2th , strcat('th',num2str(i) ,'~~ ',subtitle )   , 'epoch' , strcat('th',num2str(i)));     
    end
end
for i = 1:4   %length(nn.tracking.accuracy_val)     % ���μ���ÿ�����Լ��Ľ��
    nnfigure(nn.tracking.accuracy_val{i}   , address_2th , strcat('validation accuracy rate (set', num2str(i), ') ~~ ',subtitle ) , 'epoch' , 'Classification rate');    % ��֤��ȷ������
    nnfigure(nn.tracking.loss_val{i}       , address_2th , strcat('validation error (set', num2str(i), ') ~~ ',subtitle )  , 'epoch' , 'Error');                         % ��֤�������
end
%}

% �������  the training and teating accuracies and losses are listed and saved
accuracy_loss_val = [];
for i = 1:length(nn.tracking.accuracy_val)     % ���μ���ÿ�����Լ��Ľ��
    accuracy_loss_val = [accuracy_loss_val ;  nn.tracking.accuracy_val{i}(end)];    % ��֤������ȷ�������];
end
nn.tracking.performance = [ 
                            nn.tracking.accuracy_train(end) ;          % ѵ��������ȷ��    
                            nn.tracking.loss_train(end)  ]                      
% ����flagȷ����α�����Щ����   
switch flag
    case 'acfuns'
        xlswrite(strcat(address_1th,'\acc&loss_result.xls'),nn.tracking.performance', flag ,strcat('C',num2str(i_acfun+1)));   % �����н���������α��档�������зֱ��Ǳ���ĵ�ַ����Ҫ����ľ��󣬱��浽�ı���λ�ã�
        xlswrite(strcat(address_1th,'\acc&loss_result.xls'),accuracy_loss_val', flag ,strcat('H',num2str(i_acfun+1)));   % �����н���������α��档�������зֱ��Ǳ���ĵ�ַ����Ҫ����ľ��󣬱��浽�ı���λ�ã�
end

fprintf('���������������������������� sub over ����������������������������������\n');
