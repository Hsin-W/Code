function e=Criticaldwtdeno(s,x,wname,n,th,sorh)
% s------Ⱦ���ź�
% x------ԭ�ź�
% wname--С������
% n-----�ֽ����
% th----��ֵ��������һ������
% e-----���������
% =========================================================================
%                          Written by Yi Qin
% =========================================================================
nt=length(th);   %��ֵ���г���

% [h,g,rh,rg]=wfilters(wname);
% [r,ww]=freqz(g);
% th=th*std(r);

for pp=1:nt
   thr=th(pp)*ones(1,n);
   y = wdencmp('lvd',s,wname,n,thr,sorh);
   e(pp) = sqrt(mean(mean((y-x).^2)));
end