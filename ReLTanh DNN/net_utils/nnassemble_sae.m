% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ���----������ae��ϳ�NN���磬�Ա���з��򴫲�
% the SAEs and the classifier of DNN are combined and assembled as a NN for
% backpropagation process
function nn = nnassemble_sae(sae)           % dbn�а������RBMԤѵ�������е�Ȩֵ��ƫ��ֵ��

numlayer = numel(sae.opts.netsize);     % �����ܲ���

nn.net{1}.w = [0];        % ����ĵ�һ�����ص�Ȩֵƫ��ֵ����0���˴������ÿһ���������Ľڵ㣬ƫ��ֵ�Լ�������ǰһ�������Ȩֵ���ߣ�ʵ���ϵ�һ��ֻ��һ��װ�Σ�û�����ã���ʵ���У���һ���������������κδ���
nn.net{1}.c = [0];

for i=1:length(sae.ae)               % ���μ���ÿ��RBM
    nn.net{i+1}.w = sae.ae{i}.net{2}.w;     % ���ν����Ԥѵ����RBM��Ȩֵ��ƫ��ֵ��ȡ������װ��nn��������
    nn.net{i+1}.c = sae.ae{i}.net{2}.c;
    nn.net{i+1}.k_PReLU = sae.ae{i}.net{2}.k_PReLU;
    nn.net{i+1}.thp = sae.ae{i}.net{2}.thp;
    nn.net{i+1}.thn = sae.ae{i}.net{2}.thn;
end
    nn.net{numlayer}.w = sae.classifier.w;    % �������װ
    nn.net{numlayer}.c = sae.classifier.c;