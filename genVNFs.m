function VNFs = genVNFs(n)
    %n：VNF的总数

    %生成部署VNF的计算资源成本-均匀分布
    MinResourcesCost = 200;
    MaxResourcesCost = 250;
    rc = randi([MinResourcesCost, MaxResourcesCost], 1, n);

    %生成部署VNF的时间成本-均匀分布
    MinTimeCost = 1;
    MaxTimeCost = 2;
    tc = randi([MinTimeCost, MaxTimeCost], 1, n);

    for i = 1 : n
        VNFs(i) = VNF(i, rc(i), tc(i));
    end
    out2file(VNFs);
end

function VNF = VNF(id, resourcesCost, timeCost)
    %id：VNF的ID 
    %resourcesCost：VNF的计算资源成本
    %timeCost：安装该VNF所需的时间
    VNF.id = id;
    VNF.resourcesCost = resourcesCost;
    VNF.timeCost = timeCost;
end

function out2file(VNFs)
    fid = fopen('vnfs.txt', 'w');
%     fprintf(fid, '%s\n', '#id rc tc');
    for i = 1 : length(VNFs)
        fprintf(fid, '%d %d %d\n', VNFs(i).id, VNFs(i).resourcesCost, VNFs(i).timeCost);
    end
    fclose(fid);
end