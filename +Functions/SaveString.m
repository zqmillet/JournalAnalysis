function SaveString(String, FileName)
  File = fopen(FileName, 'w+', 'n', 'UTF-8');
  fprintf(File, '%s', String);
  fclose(File);
end

