function test2(nodes, G, n, requests, vnfs)

    TotalVNFs = length(vnfs);
    N_Reqs = length(requests);
    vnfMap = zeros(TotalVNFs, n); %vnf�����ͼ
    blockedReq = [];
    for i = 1 : length(requests)
%         disp(requests(i));
        [path, totalDelay] = dijkstra(nodes, G, requests(i));
%         disp('the shortest path:');
%         disp(path);
%         disp('total delay:');
%         disp(totalDelay);
        if totalDelay > requests(i).maxTolerableDelay
%             disp('Delay does not meet the requirement. blocked req:');
%             disp(requests(i));
            blockedReq(end + 1) = i;
            continue;
        end
        [nodes, vnfMap, isSuccess] = deploy2(path, nodes, vnfs, requests(i), vnfMap);
        if isSuccess == 0
%             disp('blocked req:');
%             disp(requests(i));
            blockedReq(end + 1) = i;
        end
    end
    disp('********************test2***********************');
    fprintf('blocked Ratio: %s\n', num2str(length(blockedReq)/N_Reqs));
%     disp(length(blockedReq)/N_Reqs);
%     disp(vnfMap);
    
    %ͳ��vnf����
    nums = sum(vnfMap(:) == 1);
    fprintf('the Total Numbers of vnf: %d\n', nums);
end


