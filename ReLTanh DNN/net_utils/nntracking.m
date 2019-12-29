% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ����������ټ�¼ÿһ��ѭ������������
% for tracking the states such as training accracies and losses during the
% training process
function tracking = nntracking(nn, tracking, train_x, train_y, val_x, val_y)   % �����õ�tarin_xֵ���е�ѵ��

assert(nargin == 4 || nargin == 6, 'Wrong number of arguments');      % �������ı���������4����6 �ͱ���4 ��û����֤����6�ǰ�����֤��

% ѵ�����ݼ�
nn = nnff(nn, train_x, train_y);         % ��������һ���Լ���
[~, output] = max(nn.net{end}.out,[],2);      % �ҳ����������ֵ��Ϊ���жϵ���ȷֵ
[~, label] = max(train_y,[],2);              % ��ֵ����ǩ���ֵ��Ϊ���жϵ���ȷֵ

row = find(output ~= label);             % ������Ƚϣ��ҳ�����ͬ��Ԫ�ص�����
tracking.fail_train              = [label(row),output(row)];                % �õ��б�ʧ�ܵĽ��
tracking.accuracy_train(end + 1) = 1 - (numel(row) / size(train_y, 1));     % �õ�������
tracking.loss_train(end + 1)     = nn.loss;   % ѵ�����

temp_thp = [];
temp_thn = [];
for i = 2: length(nn.net)-1
    temp_thp = [temp_thp;nn.net{i}.thp];  
    temp_thn = [temp_thn;nn.net{i}.thn];  
end
tracking.thp(:,end + 1)  = temp_thp;   
tracking.thn(:,end + 1)  = temp_thn;
    


% ��֤���ݼ�
if nargin == 6                            % �������ı�����Ϊ6������������֤��
    for i = 1: length(val_x)              % ���μ���ÿһ����֤����    
        nn = nnff(nn, val_x{i}, val_y{i});          % һ���Լ�����֤��
        [~, output] = max(nn.net{end}.out,[],2);   % �ҳ����������ֵ��Ϊ���жϵ���ȷֵ
        [~, label]  = max(val_y{i},[],2);             % �ҳ����������ֵ��Ϊ���жϵ���ȷֵ

        row = find(output ~= label);     
        tracking.fail_val{i}              = [label(row),output(row)];              % �õ��б�ʧ�ܵĽ��
        tracking.accuracy_val{i}(end + 1) = 1 - (numel(row) / size(val_y{i}, 1));     % �õ�������
        tracking.loss_val{i}(end + 1)     = nn.loss;
    end

end



