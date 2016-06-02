function [Distribution] = GetDistribution(Data, StepNumber)
  if numel(Data) ~= max(size(Data))
    error('There is an error in the size of input data!');
  end

  if size(Data, 1) ~= 1
    Data = Data';
  end
  
  Max = max(Data);
  Min = min(Data);

  Step= (Max - Min)/(StepNumber - 1);

  Count = 0;
  for i = Min:Step:Max
      Count = Count + 1;
  end

  Distribution = zeros(1, Count);

  for i = 1:size(Data,2)
      Distribution(fix((Data(1, i) - Min)/Step) + 1) = Distribution(fix((Data(1, i) - Min)/Step) + 1) + 1;        
  end

  Distribution = [(Min:Step:Max)', Distribution']; 
end

