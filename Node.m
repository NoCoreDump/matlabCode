function node = Node(id, neighbor, bw, w, totalResources, restResources, embeddedVNFs)
    %node�ṹ��Ĺ��캯��
    %id:�ڵ�ID 
    %neighbor���ڽӽڵ�
    %bw:�����±����ڽӽڵ��Ӧ
    %weight:��·Ȩ��,�±����ڽӵ��Ӧ
    %totalResources:�ڵ��ܵ���Դ
    %restResources���ڵ�ʣ����Դ
    %embeddedVNFs���ýڵ��Ѿ������VNF
    node.id = id;
    node.neighbor = neighbor;
    node.bw = bw;
    node.weight = w;
    node.totalResources = totalResources;
    node.restResources = restResources;
    node.embeddedVNFs = embeddedVNFs;
end