function [nodes, G, n] = genNodes(file)
%file:���������ļ�[u v]
%nodes:�ṹ������
%n���ڵ���
%m������
    fid = fopen(file, 'r+');
    matrix = textscan(fid, '%d %d');
    first = matrix{1, 1};
    second = matrix{1, 2};
    n = first(1);  %�ڵ���
    m = second(1);  %����
    disp(['node��', num2str(n)]);
    disp(['edges��',num2str(m)]);
    
    %�ڵ�����Դ��Χ
    MinResources = 800;
    MaxResources = 1000;
    %���ɾ��ȷֲ��Ľڵ���Դ
    resources = randi([MinResources, MaxResources], 1, n);
    
    %���ɾ��ȷֲ�����·����
    MinBW = 500;
    MaxBW = 600;
    bw = randi([MinBW, MaxBW], 1, m);
    
    %���ɾ��ȷֲ�����·Ȩ�أ�10ms
    MinWeight = 1;
    MaxWeight = 2;
    weight = randi([MinWeight, MaxWeight], 1, m);
    for u = 1 : n
        nodes(u) = Node(u, [], [], [], resources(u), resources(u), []);
    end
    for i = 2 : m + 1
        u = first(i);
        v = second(i);
       
        nodes(u).neighbor(end + 1) = v;
        nodes(u).bw(end + 1) = bw(i-1);
        nodes(u).weight(end + 1) = weight(i-1);
    end
    fclose(fid);
    %�ڽӾ���
    G = zeros(n);
    for i = 1 : n
        adj = nodes(i).neighbor;
        for j = 1 : length(adj)
            G(i,adj(j)) = nodes(i).weight(j);
        end
    end
    disp(G);
    out2file(nodes, n); %������ļ� id totaResources {(v1 bw1 weight1)(v2 bw2 weight2)...} 
end

function out2file(nodes, n)
    fid = fopen('testNodes1.txt', 'w');
    for i = 1 : n
        fprintf(fid, '%d %d %d%s', nodes(i).id, nodes(i).totalResources, nodes(i).restResources, ',');
        for j = 1 : length(nodes(i).neighbor)
            fprintf(fid, '%d %d %d%s', nodes(i).neighbor(j), nodes(i).bw(j), nodes(i).weight(j), ',');
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
end
        