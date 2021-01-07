function [nodes, vnfMap, isSuccess] = deploy2(path, nodes, vnfs, req, vnfMap)
    %SFC based service provisioning...�еĲ��𷽰�
    %path:���·��
    %nodes�����˽ڵ�
    %vnfs:VNFs
    %req����������
    %vnfMap:vnf�ڽڵ��ϵĲ������
    %isSuccess���Ƿ�ɹ�����
    
    sfcSeq = req.sfcSeq;
    pathLen = length(path);
    restRsc = zeros(pathLen);  %�ڵ�ʣ����Դ�����ɹ�ʱ����restRsc���µ�nodes�У����򲻸���
    isSuccess = 0;
    pathSet = zeros(pathLen, 2);  %�ڵ㼯�ϣ���һ��ID���ڶ���Ȩ��
    for i = 1 : pathLen
        pathSet(i, 1) = i;
        res = nodes(path(i)).restResources - req.resources;
        restRsc(i) = res;
        c = 1;
        for f = sfcSeq
            if vnfMap(f, path(i))
                c = c + 1;
            end
        end
        pathSet(i, 2) = c * res;
    end
%     disp('*************pathSet****************');
%     disp(pathSet);
%     pathSet = sortrows(pathSet, -2);
%     disp(pathSet);
    
    requiredResources = 0;
    for f = sfcSeq
        requiredResources = requiredResources + vnfs(f).resourcesCost;
    end
    
    for i = 1 : pathLen
        index = pathSet(i, 1);
        if restRsc(index) >= requiredResources
            isSuccess = 1;
            nodes = updateNodes(nodes, restRsc, path);
            u = path(index);
            for f = sfcSeq
                vnfMap(f, u) = 1;
            end
            break;
        end
    end
end

function nodes = updateNodes(nodes, restRsc, path)
    for i = 1 : length(path)
        u = path(i);
        nodes(u).restResources = restRsc(i);
    end
end