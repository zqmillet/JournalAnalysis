Directories = {
  'AnnualReviewsInControl', ...
  'ProceedingsOfTheIEEE', ...
  'IEEETransactionOnIndustrialElectronics', ...
  'IEEETransactionOnIndustrialInformatics', ...
  'IEEETransactionOnInformationForensicsAndSecurity', ...
  'SafetyScience'
};

% Handle the raw data
for i = 1:numel(Directories)          
  Data = importdata(['./Journals/', Directories{i},'/References.dat']);

  KeyList = Data.textdata;
  ReviewTimeList = Data.data(:, 1);
  PageNumberList = Data.data(:, 2) + 1;

  disp(['Handling the data of ', Directories{i}, '.']);
  Distribution = Functions.GetDistribution(ReviewTimeList, 15);
  SavePath = ['./Data/ReviewTimeDistribution/', Directories{i}, '.dat'];
  Functions.SaveVariable(Distribution, SavePath);

  Distribution = Functions.GetDistribution(PageNumberList, 10);
  SavePath = ['./Data/PageNumberDistribution/', Directories{i}, '.dat'];
	Functions.SaveVariable(Distribution, SavePath);
end

% Generate PDF file
for i = 1:numel(Directories) 
  TemplateString = fileread('./Templates/ReviewTimeDistribution.tex');
  TemplateString = strrep(TemplateString, '{{FileName}}', Directories{i});
  TeXFile = fopen('TempFile.tex', 'w+', 'n', 'UTF-8');
  fprintf(TeXFile, '%s', TemplateString);
  fclose(TeXFile);
  
  disp(['Generating the PDF files of ', Directories{i}, '.']);
  [~, ~] = system('xelatex TempFile.tex');
  if exist('TempFile.pdf', 'file')
    movefile('TempFile.pdf', ['./Figures/ReviewTimeDistribution/', Directories{i}, '.pdf'])
  else
    error('There is not pdf file!');
  end
  
  TemplateString = fileread('./Templates/PageNumberDistribution.tex');
  TemplateString = strrep(TemplateString, '{{FileName}}', Directories{i});
  TeXFile = fopen('TempFile.tex', 'w+', 'n', 'UTF-8');
  fprintf(TeXFile, '%s', TemplateString);
  fclose(TeXFile);
  
  [~, ~] = system('xelatex TempFile.tex');
  if exist('TempFile.pdf', 'file')
    movefile('TempFile.pdf', ['./Figures/PageNumberDistribution/', Directories{i}, '.pdf'])
  else
    error('There is not pdf file!');
  end
end

% Convert PDF file to PNG file
GhostScript = 'C:\Program Files\gs\gs9.19\bin\gswin64c.exe';
if ~exist(GhostScript, 'file')
  error('There is no GhostScript!');
end
for i = 1:numel(Directories)
  disp(['Converting PDF file of ', Directories{i},' to PNG file.']);
  PDFFileName = ['Figures/ReviewTimeDistribution/', Directories{i}, '.pdf'];
  PNGFileName = ['Figures/ReviewTimeDistribution/', Directories{i}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r200 -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end
  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
  
  PDFFileName = ['Figures/PageNumberDistribution/', Directories{i}, '.pdf'];
  PNGFileName = ['Figures/PageNumberDistribution/', Directories{i}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r200 -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end
  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
end

% Clear Temp File
disp('Deleting the temporary files.')
delete('*.asv');
delete('*.aux');
delete('*.fdb_latexmk');
delete('*.fls');
delete('*.synctex.gz');
delete('*.log');
delete('Figures\PageNumberDistribution\*.pdf');
delete('Figures\ReviewTimeDistribution\*.pdf');
delete('TempFile.*');
