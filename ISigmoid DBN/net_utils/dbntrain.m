% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
%% �Ӻ�������DBN�е�ÿ��RBMԤѵ�����ܿ��ƺ���
% RBM (the basic block is pretrained as following)
function dbn = dbntrain(dbn, x)
n = numel(dbn.rbm);    % RBM�ĸ���

% ��һ��RBM��֮���Խ�RBM1������������ΪRBM1������ֵ��ԭʼ���ݣ���֮���RBM������ֵ����ǰһ��RBM�������ģ�
disp(['%%%%%%%%%%%%%%% rbm1 %%%%%%%%%%%%%%%%']);     % ���һ����ǣ��Ա�۲����
dbn.rbm{1} = rbmtrain(dbn.rbm{1}, x, dbn.opts);      % ѵ��RBM

% ������RBM
for i = 2 : n      % ���μ���ÿ��RBM
    disp(['%%%%%%%%%%%%%%% rbm',num2str(i),' %%%%%%%%%%%%%%%%']);    % ���һ����ǣ��Ա�۲����
    x = rbmup(dbn.rbm{i - 1}, x);                                    % ����ǰһ��RBMԤѵ���õ���Ȩֵ��ƫ��ֵ���㱾��RBM������ֵ
    dbn.rbm{i} = rbmtrain(dbn.rbm{i}, x, dbn.opts);                  % ѵ��RBM
end


