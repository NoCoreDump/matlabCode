function main()
    %生成数据
    TotalVNFs = 6;  %VNF的种类
    N_Reqs = 100;
    %生成数据
    [nodes, G, n] = genNodes('pdh.txt');
%     [nodes, G, n] = readNodesFile('nodes.txt');

    requests = genRequests(TotalVNFs, N_Reqs, n);
%     requests = readReqFile('service_request.txt');

    vnfs = genVNFs(TotalVNFs);
%     vnfs = readVNFsFile('vnfs.txt');
    test1(nodes, G, n, requests, vnfs);
    test2(nodes, G, n, requests, vnfs);
end


