TotalVNFs = 20;  %VNFs��������

%����Χ��Сֵ����λMbps
MinBW = 1;
MaxBW = 10;
%���������ʱ��Χ��Сֵ����λ��ms
MinDelay = 50;  
MaxDelay = 100; 

%���������ȷ�Χ
MinSfcLen = 3;
MaxSfcLen = 5;

%CPU���󣬵�λ��MIPS
MinResources = 1;
MaxResources = 10;

%service request�ĸ���
N = 20;
idx = 1;


lam = 5;  %���ɷֲ��Ĳ�����ƽ����λʱ���ڵ�����������
% x = 0:1:30;   %����Ĵ���
% p = poisspdf(x,lam);  %�����ܶ�
% plot(x, p);
% y = poisscdf(x, lam);  %���ʷֲ�
% plot(x, y);

samples = poissrnd(lam, 1, N);   %���Ӳ��ɷֲ�������
disp(samples);
% counts = min(samples):1:max(samples);
% hist(samples, counts);  %Ƶ�ʷֲ�ֱ��ͼ

%�������󵽴�ʱ�������Ӳ��ɷֲ�
t0 = 0; %��ʼʱ��0
arriveTime = zeros(1, N);
for i = 2 : N
    arriveTime(i) = arriveTime(i-1) + samples(i);
end
% disp('request arrive time');
% disp(arriveTime);

bw = randi([MinBW, MaxBW], 1, N);
% disp('bandwidth');
% disp(bw);

sfcLen = randi([MinSfcLen, MaxSfcLen], 1, N);
% disp('sfc length');
% disp(sfcLen);

resources = randi([MinResources, MaxResources], 1, N);
% disp('CPU resources');
% disp(resources);

delay = randi([MinDelay, MaxDelay], 1, N);
% disp('tolerable delay');
% disp(delay);

sfcSeq = zeros(N, MaxSfcLen);

for i = 1 : N
    len = sfcLen(i);
    seq = randperm(TotalVNFs, len);
    request(i) = Request(i, arriveTime(i), bw(i), resources(i), delay(i), sfcLen(i), seq);
end    
% out to file
fid = fopen('service_request.txt', 'w');
fprintf(fid, '%s\n','#id,arriveTime,bw,resources,maxTolerableDelay,sfcLen,sfcSeq');
for i = 1 : N
    fprintf(fid, '%d %d %d %d %d %d ', request(i).id, request(i).arriveTime, request(i).bw, request(i).resources, ...
        request(i).maxTolerableDelay, request(i).sfcLen);
    for j = 1 : request(i).sfcLen
        fprintf(fid, '%d ', request(i).sfcSeq(j));
    end
    fprintf(fid, '\n');
end
fclose(fid);