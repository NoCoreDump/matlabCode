function [nodes, vnfMap, isSuccess] = deploy2(path, nodes, vnfs, req, vnfMap)
    %SFC based service provisioning...中的部署方案
    %path:最短路径
    %nodes：拓扑节点
    %vnfs:VNFs
    %req：服务请求
    %vnfMap:vnf在节点上的部署情况
    %isSuccess：是否成功部署
    
    sfcSeq = req.sfcSeq;
    pathLen = length(path);
    restRsc = zeros(pathLen);  %节点剩余资源，当成功时，将restRsc更新到nodes中，否则不更新
    isSuccess = 0;
    pathSet = zeros(pathLen, 2);  %节点集合，第一列ID，第二列权重
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