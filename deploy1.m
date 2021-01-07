function [nodes, vnfMap, isSuccess] = deploy1(path, nodes, vnfs, req, vnfMap)
    %path:���·��
    %nodes�����˽ڵ�
    %vnfs:VNFs
    %req����������
    %vnfMap:vnf�ڽڵ��ϵĲ������
    %isSuccess���Ƿ�ɹ�����
    sfcSeq = req.sfcSeq;
    map = vnfMap;
    pathLen = length(path);
    restRsc = zeros(pathLen);  %�ڵ�ʣ����Դ�����ɹ�ʱ����restRsc���µ�nodes�У����򲻸���
    isSuccess = 0;
    
    embeddedSeq = [];  %embedded vnf�����е�f���ڵĽڵ�
    belong = [];  %embeddedSeq�е�f���ڵĽڵ㣬��path�е��±�
    for i = 1 : pathLen
        u = path(i);
        restRsc(i) = nodes(u).restResources - req.resources;
        for f = sfcSeq
            if map(f, u)
                embeddedSeq(end + 1) = f;
                belong(end +1) = i;
            end
        end
    end
    [lcs, index1, location] = getLCS(sfcSeq, embeddedSeq);
    
    if ~isempty(lcs)    %���������в�Ϊ��
        loc = find(index1 == 0);
        if isempty(loc)
            isSuccess = 1;
            return;
        end
        for idx = loc
            if index1(idx)
                continue;
            else
                i = idx;
                l = i;
                requiredResources = 0;
                if i > 1
                    l = i - 1;
                end
                while i <= length(sfcSeq) && index1(i) == 0
                    requiredResources = requiredResources + vnfs(sfcSeq(i)).resourcesCost;
                    i = i + 1;
                end
                r = i;
                if location(l) == 0
                    start = 1;
                else
                    start = belong(location(l));
                end
                if r > length(sfcSeq)
                    endidx = pathLen;
                else
                    endidx = belong(location(r));
                end
                k = idx;
                m = start;
                while k <= length(sfcSeq) && ~index1(k) && m <= endidx
                    f = sfcSeq(k);
                    node = path(m);
                    if restRsc(m) >= vnfs(f).resourcesCost
                        index1(k) = 1;
                        restRsc(i) = restRsc(i) - vnfs(f).resourcesCost;
                        map(f, node) = 1;
                        k = k + 1;
                    else
                        m = m + 1;
                    end
                end
                if m > endidx
                    break;
                end
            end
        end
        isSuccess = 1;
        nodes = updateNodes(nodes, restRsc, path);  %���½ڵ��ʣ����Դ
        vnfMap = map;
        return;
    end
    j = 1;
    for k = 1 : length(sfcSeq)
        if j > pathLen
            return;
        end
        node = path(j);
        if restRsc(j) >= vnfs(sfcSeq(k)).resourcesCost
            map(sfcSeq(k), node) = 1;
            restRsc(j) = restRsc(j) - vnfs(sfcSeq(k)).resourcesCost;
        else
            j = j + 1;
        end
    end
    isSuccess = 1;
    nodes = updateNodes(nodes, restRsc, path);  %���½ڵ��ʣ����Դ
    vnfMap = map; 
end

function nodes = updateNodes(nodes, restRsc, path)
    for i = 1 : length(path)
        u = path(i);
        nodes(u).restResources = restRsc(i);
    end
end