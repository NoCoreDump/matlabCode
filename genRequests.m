function requests = genRequests(TotalVNFs, N, n)
    reqFileName = 'service_request.txt';
    %TotalVNFs:VNFs��������
    %N:service request�ĸ���
    %n:�ڵ��������������src��dst
    
    %����Χ��Сֵ����λMbps
    MinBW = 1;
    MaxBW = 5;
    %���������ʱ��Χ��Сֵ����λ��10ms
    MinDelay = 5;  
    MaxDelay = 10; 

    %���������ȷ�Χ�����Ӿ�ֵΪ3����̫�ֲ�
    MinSfcLen = 3;
    MaxSfcLen = 3;
    avgSfcLen = 3;
    sigma = 1;
    sfcLen = randi([MinSfcLen, MaxSfcLen], 1, N);  %���ȷֲ�
%     sfcLen = normrnd(avgSfcLen, sigma, 1, N);

    %CPU���󣬵�λ��MIPS
    MinResources = 80;
    MaxResources = 100;

    %��Ծʱ������
    MinActTime = 1;
    MaxActTime = 10;
    actTimes = randi([MinActTime, MaxActTime], 1, N);
    
    lam = 2;  %���ɷֲ��Ĳ�����ƽ����λʱ���ڵ�������������ƽ��20ms����һ��
    % x = 0:1:30;   %����Ĵ���
    % p = poisspdf(x,lam);  %�����ܶ�
    % plot(x, p);
    % y = poisscdf(x, lam);  %���ʷֲ�
    % plot(x, y);
    
    samples = poissrnd(lam, 1, N);   %���Ӳ��ɷֲ�������
%     disp(samples);
    % counts = min(samples):1:max(samples);
    % hist(samples, counts);  %Ƶ�ʷֲ�ֱ��ͼ
    
%     �������󵽴�ʱ�������Ӳ��ɷֲ�
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

            
