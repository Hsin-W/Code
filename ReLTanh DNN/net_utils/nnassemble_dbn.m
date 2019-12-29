% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ���----��rbms��classifier��ϳ�NN���磬�Ա���з��򴫲�
% the rbms and the classifier of DBN are combined and assembled as a NN for
% backpropagation process
function nn = nnassemble_dbn(dbn, hyperpara)           % dbn�а������RBMԤѵ�������е�Ȩֵ��ƫ��ֵ��

numlayer = numel(dbn.opts.netsize);     % �����ܲ���

nn.net{1}.w = [0];        % ����ĵ�һ�����ص�Ȩֵƫ��ֵ����0���˴������ÿһ���������Ľڵ㣬ƫ��ֵ�Լ�������ǰһ�������Ȩֵ���ߣ�ʵ���ϵ�һ��ֻ��һ��װ�Σ�û�����ã���ʵ���У���һ���������������κδ���
nn.net{1}.c = [0];

for i=1:length(dbn.rbm)               % ���μ���ÿ��RBM
    nn.net{i+1}.w = dbn.rbm{i}.w;     % ���ν����Ԥѵ����RBM��Ȩֵ��ƫ��ֵ��ȡ������װ��nn��������
    nn.net{i+1}.c = dbn.rbm{i}.c;
    
    nn.net{i+1}.k_PReLU = hyperpara.k_PReLU ;  %*ones(1,dim(2)) ;
    nn.net{i+1}.thp = hyperpara.thp ;          %*ones(1,dim(2)) ;
    nn.net{i+1}.thn = hyperpara.thn;           %*ones(1,dim(2)) ;
end

nn.net{numlayer}.w = dbn.classifier.w;    % �������װ
nn.net{numlayer}.c = dbn.classifier.c;