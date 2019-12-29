function y=denseftdeno(x,af,n,sorh)
% x------noisy signal Ⱦ���ź�
% af-----analysis filter bank �����˲�����
% n-----the number of levels �ֽ����
% sorh----'s' soft thresholding or 'h' hard thresholding ����ֵ��Ӳ��ֵ
% y-----denoised signal ������
% =========================================================================
%                          Written by Yi Qin
% =========================================================================

sf = af(end:-1:1,:);
h1=af(:,2);
h2=af(:,3);
[r1,ww]=freqz(h1);
[r2,ww]=freqz(h2);

w = denseft(x, n, af);
%thr = sqrt(2*log(length(x)))*ones(1,2*n);%*(wnoisest(swd(2,:))+wnoisest(swd(2,:)))/2; %%fixed threshold 
thr = 1*wnoisest(w{1}{1})/std(r1)*(0.3936 + 0.1829*(log(length(x))/log(2)))*ones(1,2*n); %%Minimaxi threshold
w1=w;

%%%%Threshold denoising
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


