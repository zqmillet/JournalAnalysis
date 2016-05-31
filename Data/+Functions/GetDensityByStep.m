function [xout] = GetDensityByStep(x, step)
    % x = x(1,2:size(x,2));
    
    x = x';
    
    Max = max(x);
    Min = min(x);
    
    count = 0;
    for i = Min : step : Max
        count = count + 1;
    end
    
    st = zeros(1, count);
    
    for i = 1:size(x,2)
        st(fix((x(1, i) - Min)/step) + 1) = st(fix((x(1, i) - Min)/step) + 1) + 1;        
    end
    
    % bar(Min:step:Max, st);
    % st = st/size(x,2);
    xout = [(Min:step:Max)', st']; 
end

