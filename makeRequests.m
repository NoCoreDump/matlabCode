TotalVNFs = 20;  %VNFs的种类数

%带宽范围最小值，单位Mbps
MinBW = 1;
MaxBW = 10;
%最大容忍延时范围最小值，单位：ms
MinDelay = 50;  
MaxDelay = 100; 

%服务链长度范围
MinSfcLen = 3;
MaxSfcLen = 5;

%CPU需求，单位：MIPS
MinResources = 1;
MaxResources = 10;

%service request的个数
N = 20;
idx = 1;


lam = 5;  %泊松分布的参数：平均单位时间内到达的请求个数
% x = 0:1:30;   %到达的次数
% p = poisspdf(x,lam);  %概率密度
% plot(x, p);
% y = poisscdf(x, lam);  %概率分布
% plot(x, y);

samples = poissrnd(lam, 1, N);   %服从泊松分布的序列
disp(samples);
% counts = min(samples):1:max(samples);
% hist(samples, counts);  %频率分布直方图

%服务请求到达时间间隔服从泊松分布
t0 = 0; %初始时刻0
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