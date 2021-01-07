%优先队列实现
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
%比较两个对象
    ret = a.time < b.time;
end




