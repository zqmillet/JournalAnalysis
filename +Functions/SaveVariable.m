function SaveVariable(Variable, FileName)
  if numel(Variable) ~= 0
    save(FileName, '-ascii', 'Variable');
  end
end

