function [path, totalDelay] = dijkstra(nodes, G, request)
    %nodes:���˽ڵ�
    %G:ʱ���ڽӾ���
    %request��������������
    home = request.src;
    target = request.dst;
%     disp('src:');
%     disp(home);
%     disp('dst:');
%     disp(target);
    pq = pqEnq([], Path(home, 0));
    n = length(nodes);
    vis = zeros(1, n);  %�������Ľڵ㼯��
    invalidNodes = zeros(1, n);  %��Դ����Ľڵ�
    pre = zeros(1, n);
    vis(home) = 1;
    done = zeros(1, n);
    weight = zeros(1, n);
    while ~isempty(pq)
        [pq, cur] = qPop(pq);
        done(cur.cur_node) = 1;
        u = nodes(cur.cur_node);
        curWeight = cur.weight;
        weight(cur.cur_node) = cur.weight;
        if (cur.cur_node == target) 
            break;
        end
        for i = 1 : length(u.neighbor)
            v = u.neighbor(i);
            %�ڽӵ��ʣ����Դ����·������������
            if done(v) || invalidNodes(v) == 1
                continue;
            end
            if nodes(v).restResources < request.resources || u.bw(i) < request.bw
                invalidNodes(v) = 1;
                vis(v) = 1;
                continue;
            end
            beta1 = request.resources / nodes(v).restResources;
            beta2 = request.bw / u.bw(i);
            beta = beta1 + beta2;
%             beta = 1;
            w = u.weight(i) * beta + curWeight;  
            
            if vis(v) == 0
                p = Path(v, w);
                pq = pqEnq(pq, p);
                pre(v) = u.id;
                vis(v) = 1;
            else
                [pq, isUpdate] = qUpdateMinVal(pq, v, w);
                if isUpdate
                    pre(v) = u.id;
                end
            end 
        end
    end
    path = getPath(pre, home, target);
    totalDelay = getDelay(G, path);
        
end
function delay = getDelay(G, path)
    if isempty(path)
        delay = 0;
        return;
    end
    pre = path(1);
    delay = 0;
    for i = 2 : length(path)
        cur = path(i);
        delay = delay + G(pre, cur);
        pre = cur;
    end
    
end

function path = getPath(pre, src, dst)
    %pre��ÿ���ڵ����һ���ڵ�
    p = pre(dst);
    path = [];
    while p ~= 0 && p ~= src
        path = [p path];
        p = pre(p);
    end
    if p == 0
        path = [];
        return;
    end
    path(end + 1) = dst;
    path = [src path];
end

function ret = Path(node, weight)
    ret.cur_node = node;
    ret.weight = weight;
end


%���ȶ���ʵ��
function pq = pqEnq(pq, item)
    in = 1;
    at = length(pq) + 1;
    while in <= length(pq)
        if compare(item, pq{in})
            at = in;
            break;
        end
        in = in + 1;
    end
    pq = [pq(1:at-1) {item} pq(at:end)];
end


function ret = compare(a, b)
%�Ƚ���������
    ret = a.weight < b.weight;
end

function q = qEnq(q, data)
    %���
    q = [q {data}];
end

function [q, ele]= qPop(q)
    %����
    ele = q{1};
    q(1) = [];
end
function q = qDel(q, item)
    for i = 1: length(q)
        if q{i}.cur_node == item
            q(i) = [];
        end
    end
end

function [q, isUpdate] = qUpdateMinVal(q, u, w)
    %���½ڵ����СȨ��
    isUpdate = 0;  %�Ƿ������Ȩ��
    for i = 1: length(q)
        if q{i}.cur_node == u
            if q{i}.weight > w
                p = Path(u, w);
                q(i) = [];
                q = pqEnq(q, p);
                isUpdate = 1;
            end
            break;
        end
    end
end