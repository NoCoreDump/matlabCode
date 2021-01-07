function requests = readReqFile(fileName)
    fid = fopen(fileName, 'r');
    idx = 1;
    while ~feof(fid)
        str = fgetl(fid);
        s = regexp(str, '\s+', 'split');
        requests(idx).id = str2double(char(s(1)));
        requests(idx).src = str2double(s(2));
        requests(idx).dst = str2double(s(3));
        requests(idx).arriveTime = str2double(s(4));
        requests(idx).bw = str2double(s(5));
        requests(idx).resources = str2double(s(6));
        requests(idx).maxTolerableDelay = str2double(s(7));
        requests(idx).activeTime = str2double(s(8));
        requests(idx).sfcLen = str2double(s(9));
        requests(idx).sfcSeq = [];
        for j = 1 : requests(idx).sfcLen
            requests(idx).sfcSeq(end + 1) = str2double(char(s(9+j)));
        end
        idx = idx + 1;
    end
    fclose(fid);
end