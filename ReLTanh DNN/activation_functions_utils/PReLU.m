% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
function  X = PReLU(A,nn,i)

%% ����ѧϰ

k = nn.net{i}.k_PReLU;     

X  = zeros(size(A));

idx    = find(A>=0);   
X(idx) = A(idx) * 1;

%%  С��0�Ĳ���
% ͬ�㹲��k_PReLU
% {
idx    = find(A<0);   
X(idx) = A(idx) .* k;
%}




% ÿ���ڵ��k_PReLU��ͬ
%{
[row,col,val]    = find(A<0);     % �Ծ�����ֵС��0���ⲿ�֣����䵽����ֱ�Ӹ�ֵΪ0.01
temp = A .* repmat(k,size(A,1),1);
X(row,col) = temp(row,col);
%}

