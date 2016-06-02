function SaveVariable(VariableName, FileName)
  if numel(VariableName) ~= 0
    save(FileName, '-ascii', 'VariableName');
  end
end

