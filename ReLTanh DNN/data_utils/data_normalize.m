% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
%% �Ӻ���----���ݹ�һ������
% the samples are norimalized below and three kind of scaler are offered
function [data_ed,para1,para2] = data_normalize(data,scaler,para1,para2)

% minmax ��ʽ
if strcmp(scaler,'minmax')
    if nargin == 2              % ���ֻ������һ���������Ǿ��Ƕ�ѵ�������й�һ������ʱ��Ҫ����datamin��datamax
        para1 = min(data);      % ��ȡÿһ�е���Сֵ 
        para2 = max(data);      % ��ȡÿһ�е����ֵ
    end
    data_ed = bsxfun(@rdivide,bsxfun(@minus,data,para1),(para2-para1));      % max-min��һ���� %C=bsxfun(FUNC,A,B)����FUNC��������Ծ���A��B����Ԫ��һ��һ�����㣬
                                                         %rdivide�����ҳ���minus�������  

% z-score��ʽ                                                      
elseif strcmp(scaler,'maxabs')
    if nargin == 2                  % ���ֻ������һ���������Ǿ��Ƕ�ѵ�������й�һ������ʱ��Ҫ����datamin��datamax
        para1 = 0;	             % ��ֵ
        para2 = max(max(abs(data)),eps);    % std(x)�������ÿһ�еı�׼��;   eps(x)���abs��x�������һ����������֤�����,  Ĭ�ϣ�eps=eps��1��=2.2204e-16    �� �����max�����ҳ�eps�����ʵ�������е����ֵ��Ŀ���ǽ�std�е�0�滻Ϊeps��1������Ϊ0�����ٳ䵱��ĸ
    end    
	data_ed=bsxfun(@minus,data,para1);        % bsxfun��fun,A,B������������A��B֮���ÿһ��Ԫ�ؽ���ָ���ļ��㣨����funָ������   minus��A,B��=  A -B
	data_ed=bsxfun(@rdivide,data_ed,para2);   % rdivide(A,B) = A ./ B   ʵ�ֵ������    
                                                             
                                                         
                                                         
% z-score��ʽ                                                      
elseif strcmp(scaler,'z-score')
    if nargin == 2                  % ���ֻ������һ���������Ǿ��Ƕ�ѵ�������й�һ������ʱ��Ҫ����datamin��datamax
        para1 = mean(data);	        % ��ֵ
        para2 = max(std(data),eps);    % std(x)�������ÿһ�еı�׼��;   eps(x)���abs��x�������һ����������֤�����,  Ĭ�ϣ�eps=eps��1��=2.2204e-16    �� �����max�����ҳ�eps�����ʵ�������е����ֵ��Ŀ���ǽ�std�е�0�滻Ϊeps��1������Ϊ0�����ٳ䵱��ĸ
    end    
	data_ed=bsxfun(@minus,data,para1);        % bsxfun��fun,A,B������������A��B֮���ÿһ��Ԫ�ؽ���ָ���ļ��㣨����funָ������   minus��A,B��=  A -B
	data_ed=bsxfun(@rdivide,data_ed,para2);   % rdivide(A,B) = A ./ B   ʵ�ֵ������

    

    
end                                      
                                                     