% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
% for validation process 
function [er, bad] = nntest(nn, x, y)    % ���ø�ʽ [er_train, dummy]   = nntest(nn, train_x, train_y);
    labels = nnpredict(nn, x);      % �õ�ѵ�����ݵ�������
    [dummy, expected] = max(y,[],2);    % �õ�����������
    bad = find(labels ~= expected);     % �õ��б�ʧ�ܵĽ��
    er = numel(bad) / size(x, 1);     % �õ�������
end
