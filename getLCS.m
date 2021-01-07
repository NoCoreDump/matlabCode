function [lcs, index1, location] = getLCS(seq1, seq2)
    %seq1:sfcSeq of request
    %seq2:embedded vnfs in shortest path
    %lcs:最长公共子序列
    %index1：lcs在seq1中对应的索引
    %location:sfcSeq中的公共VNF在embeddedSeq中对应的位置索引

    if isempty(seq1) || isempty(seq2)
        lcs = [];
        index1 = [];
        location = [];
        return;
    end
    len1 = length(seq1);
    len2 = length(seq2);
    dp = zeros(len1, len2);
    if seq1(1) == seq2(1)
        dp(1,1) = 1;
    end
    for i = 2 : len1
        if seq1(i) == seq2(1)
            dp(i, 1) = max(dp(i - 1, 1), 1);
        else
            dp(i, 1) = max(dp(i - 1, 1), 0);
        end
    end
    for i = 2 : len2
        if seq1(1) == seq2(i)
            dp(1, i) = max(dp(1, i - 1), 1);
        else
            dp(1, i) = max(dp(1, i - 1), 0);
        end
    end
    for i = 2 : len1
        for j = 2 : len2
            dp(i, j) = max(dp(i - 1, j), dp(i, j - 1));
            if (seq1(i) == seq2(j))
                dp(i, j) = max(dp(i, j), dp(i - 1, j - 1) + 1);
            end
        end
    end
%     disp(dp);
    k = dp(len1, len2);
    lcs = zeros(1, k);
    index1 = zeros(1, len1);
    location = zeros(1, len1); %sfcSeq中的公共VNF在embeddedSeq中对应的位置索引

    while (k > 0)
        if len2 > 1 && dp(len1, len2) == dp(len1, len2 - 1)
            len2 = len2 - 1;
        else if len1 > 1 && dp(len1, len2) == dp(len1 - 1, len2)
                len1 = len1 - 1;
            else
                lcs(k) = seq1(len1);
                index1(len1) = 1;
                location(len1) = len2;
                len1 = len1 - 1;
                len2 = len2 - 1;
                k = k - 1;
            end
        end
    end
                
end