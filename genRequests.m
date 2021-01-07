function requests = genRequests(TotalVNFs, N, n)
    reqFileName = 'service_request.txt';
    %TotalVNFs:VNFs的种类数
    %N:service request的个数
    %n:节点个数，用于生成src和dst
    
    %带宽范围最小值，单位Mbps
    MinBW = 1;
    MaxBW = 5;
    %最大容忍延时范围最小值，单位：10ms
    MinDelay = 5;  
    MaxDelay = 10; 

    %服务链长度范围，服从均值为3的正太分布
    MinSfcLen = 3;
    MaxSfcLen = 3;
    avgSfcLen = 3;
    sigma = 1;
    sfcLen = randi([MinSfcLen, MaxSfcLen], 1, N);  %均匀分布
%     sfcLen = normrnd(avgSfcLen, sigma, 1, N);

    %CPU需求，单位：MIPS
    MinResources = 80;
    MaxResources = 100;

    %活跃时长参数
    MinActTime = 1;
    MaxActTime = 10;
    actTimes = randi([MinActTime, MaxActTime], 1, N);
    
    lam = 2;  %泊松分布的参数：平均单位时间内到达的请求个数，平均20ms到达一个
    % x = 0:1:30;   %到达的次数
    % p = poisspdf(x,lam);  %概率密度
    % plot(x, p);
    % y = poisscdf(x, lam);  %概率分布
    % plot(x, y);
    
    samples = poissrnd(lam, 1, N);   %服从泊松分布的序列
%     disp(samples);
    % counts = min(samples):1:max(samples);
    % hist(samples, counts);  %频率分布直方图
    
%     服务请求到达时间间隔服从泊松分布
    arriveTime = zeros(1, N);
    for i = 2 : N
        arriveTime(i) = arriveTime(i-1) + samples(i);
    end
    % disp('request arrive time');
    % disp(arriveTime);

    bw = randi([MinBW, MaxBW], 1, N);
    % disp('bandwidth');
    % disp(bw);

    
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
        list = randperm(n, 2);
        src = list(1);
        dst = list(2);
        requests(i) = Request(i, src, dst, arriveTime(i), bw(i), resources(i), delay(i), actTimes(i), sfcLen(i), seq);
    end    
    % out to file
    fid = fopen(reqFileName, 'w');
%     fprintf(fid, '%s\n','#id,src,dst,arriveTime,bw,resources,maxTolerableDelay,sfcLen,sfcSeq');
    for i = 1 : N
        fprintf(fid, '%d %d %d %d %d %d %d %d %d', requests(i).id, requests(i).src, requests(i).dst, requests(i).arriveTime,...
            requests(i).bw, requests(i).resources,requests(i).maxTolerableDelay, requests(i).activeTime, requests(i).sfcLen);
        for j = 1 : requests(i).sfcLen
            fprintf(fid, '%d ', requests(i).sfcSeq(j));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
    
end
function ans = Request(i, src, dst, time, b, r, d, activeTime, len, seq)
    ans.id = i;
    ans.src = src;
    ans.dst = dst;
    ans.arriveTime = time;
    ans.bw = b;
    ans.resources = r;
    ans.maxTolerableDelay = d;
    ans.activeTime = activeTime;
    ans.sfcLen = len;
    ans.sfcSeq = seq;
end

            
