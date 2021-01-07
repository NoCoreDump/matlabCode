function node = Node(id, neighbor, bw, w, totalResources, restResources, embeddedVNFs)
    %node结构体的构造函数
    %id:节点ID 
    %neighbor：邻接节点
    %bw:带宽，下标与邻接节点对应
    %weight:链路权重,下标与邻接点对应
    %totalResources:节点总的资源
    %restResources：节点剩余资源
    %embeddedVNFs：该节点已经部署的VNF
    node.id = id;
    node.neighbor = neighbor;
    node.bw = bw;
    node.weight = w;
    node.totalResources = totalResources;
    node.restResources = restResources;
    node.embeddedVNFs = embeddedVNFs;
end