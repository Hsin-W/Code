% =========================================================================
%                          Written by Yi Qin and Xin Wang
% =========================================================================
% the predicted label of the model are gained below
function labels = nnpredict(nn, x)      % ���ø�ʽ��labels = nnpredict(nn, x);   % ��ѵ�����ݴ��ݽ���
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;
    
    [dummy, i] = max(nn.a{end},[],2);      % �ҳ����������ֵ��Ϊ���жϵ���ȷֵ
    labels = i;
end
