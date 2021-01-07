function [nodes, G, n] = readNodesFile(fileName)
    %return 
    %nodes:节点数据
    %G：邻接表
    %n：节点数
    %m：边数
%     fileName = 'node.txt';
    fid = fopen(fileName, 'r');
    idx = 1;
    while ~feof(fid)
        str = fgetl(fid);
        s = regexp(str, ',', 'split');
%         disp(s);
        first = regexp(char(s(1)), '\s+', 'split');
%         nodes(idx).id = str2double(first(1));
%         nodes(idx).totalResources = str2double(first(2));
%         nodes(idx).restResources = str2double(first(3));
        nodes(idx) = Node(str2double(char(first(1))), [], [], [], str2double(first(2)), str2double(first(3)), []);
        for i = 2 : length(s) - 1
            ss = regexp(char(s(i)), '\s+', 'split');
            nodes(idx).neighbor(end + 1) = str2double(char(ss(1)));
            nodes(idx).bw(end + 1) = str2double(ss(2));
            nodes(idx).weight(end + 1) = str2double(ss(3));
        end
%         disp(nodes(idx));
        idx = idx + 1;
    end
    fclose(fid);
    n = idx - 1;
     %邻接矩阵
    G = zeros(n);
    for i = 1 : n
        adj = nodes(i).neighbor;
        for j = 1 : length(adj)
            G(i,adj(j)) = nodes(i).weight(j);
        end
    end
    disp(G);
end