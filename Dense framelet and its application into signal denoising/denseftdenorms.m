function e=denseftdenorms(s,x,af,n,th,sorh)
% s------noisy signal Ⱦ���ź�
% x------original signal ԭ�ź�
% af-----analysis filter bank �����˲�����
% n-----the number of levels �ֽ����
% th----threshold ��ֵ��������һ������
% sorh----'s' soft thresholding or 'h' hard thresholding ����ֵ��Ӳ��ֵ
% e-----root-mean-square(RMS error)���������
% =========================================================================
%                          Written by Yi Qin
% =========================================================================

sf = af(end:-1:1,:);
nt=length(th);   %��ֵ���г���
h1=af(:,2);
h2=af(:,3);
[r1,ww]=freqz(h1);
[r2,ww]=freqz(h2);

w = denseft(s, n, af);

for pp=1:nt
    w1=w;
    thr=th(pp)*ones(1,2*n);
    for k = 1:n
        p   = 2*k-1;
        pc  = thr(p);        % thresholds
        cfs = w1{k}{1};
        cfs = wthresh(cfs,sorh,std(r1)*pc);
        w1{k}{1}= cfs;
        p   = 2*k;
        pc  = thr(p);        % thresholds
        cfs = w1{k}{2};
        cfs = wthresh(cfs,sorh,std(r2)*pc);
        w1{k}{2}= cfs;
    end
    y = idenseft(w1, n, sf);
    e(pp) = sqrt(mean(mean((y-x).^2)));
end


