function vnfs = readVNFsFile(fileName)
    fid = fopen(fileName, 'r');
    idx = 1;
    matrix = textscan(fid, '%d %d %d');
    id = matrix{1, 1};
    rc = matrix{1, 2};
    tc = matrix{1, 3};
    n = length(id);
    for i = 1 : n
        vnfs(i).id = id(i);
        vnfs(i).resourcesCost = rc(i);
        vnfs(i).timeCost = tc(i);
    end
    fclose(fid);
end