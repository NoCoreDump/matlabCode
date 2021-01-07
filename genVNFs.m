function VNFs = genVNFs(n)
    %n��VNF������

    %���ɲ���VNF�ļ�����Դ�ɱ�-���ȷֲ�
    MinResourcesCost = 200;
    MaxResourcesCost = 250;
    rc = randi([MinResourcesCost, MaxResourcesCost], 1, n);

    %���ɲ���VNF��ʱ��ɱ�-���ȷֲ�
    MinTimeCost = 1;
    MaxTimeCost = 2;
    tc = randi([MinTimeCost, MaxTimeCost], 1, n);

    for i = 1 : n
        VNFs(i) = VNF(i, rc(i), tc(i));
    end
    out2file(VNFs);
end

function VNF = VNF(id, resourcesCost, timeCost)
    %id��VNF��ID 
    %resourcesCost��VNF�ļ�����Դ�ɱ�
    %timeCost����װ��VNF�����ʱ��
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