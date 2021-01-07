function [nodes, G, n] = genNodes(file)
%file:网络拓扑文件[u v]
%nodes:结构体数组
%n：节点数
%m：边数
    fid = fopen(file, 'r+');
    matrix = textscan(fid, '%d %d');
    first = matrix{1, 1};
    second = matrix{1, 2};
    n = first(1);  %节点数
    m = second(1);  %边数
    disp(['node：', num2str(n)]);
    disp(['edges：',num2str(m)]);
    
    %节点总资源范围
    MinResources = 800;
    MaxResources = 1000;
    %生成均匀分布的节点资源
    resources = randi([MinResources, MaxResources], 1, n);
    
    %生成均匀分布的链路带宽
    MinBW = 500;
    MaxBW = 600;
    bw = randi([MinBW, MaxBW], 1, m);
    
    %生成均匀分布的链路权重：10ms
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
    %邻接矩阵
    G = zeros(n);
    for i = 1 : n
        adj = nodes(i).neighbor;
        for j = 1 : length(adj)
            G(i,adj(j)) = nodes(i).weight(j);
        end
    end
    disp(G);
    out2file(nodes, n); %输出到文件 id totaResources {(v1 bw1 weight1)(v2 bw2 weight2)...} 
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
        