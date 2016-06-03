% This script is used to generate the figures in the folder "Figures", which are used in "Readme.md" file, and the "Main.pdf" file.
% If you modify the raw data in the folder "Journals", please run this script to regenerate all the figures and the "Main.pdf" file. 
% Runtime Environment:
%  - Windown 10,
%  - Matlab 2016a,
%  - TeX Live 2015,
%  - GhostScript 9.19.

%% Set the directories
Directories = { ...  
  'ProceedingsOfTheIEEE', ...
  'IEEETransactionOnIndustrialElectronics', ...
  'IEEETransactionOnIndustrialInformatics', ...
  'IEEETransactionOnInformationForensicsAndSecurity', ...
  'SafetyScience', ...
  'AnnualReviewsInControl', ...
};

%% Handle the raw data
for i = 1:numel(Directories)          
  Data = importdata(['./Journals/', Directories{i},'/References.dat']);

  KeyList = Data.textdata;
  ReviewTimeList = Data.data(:, 1);
  PageNumberList = Data.data(:, 2) + 1;
  
  disp(['min: ', num2str(min(PageNumberList)), 'aver: ', num2str(mean(PageNumberList)), 'max: ', num2str(max(PageNumberList))]);
  
  % disp(['Handling the data of ', Directories{i}, '.']);
  Distribution = Functions.GetDistribution(ReviewTimeList, 15);
  SavePath = ['./Data/ReviewTimeDistribution/', Directories{i}, '.dat'];
  Functions.SaveVariable(Distribution, SavePath);

  Distribution = Functions.GetDistribution(PageNumberList, 10);
  SavePath = ['./Data/PageNumberDistribution/', Directories{i}, '.dat'];
	Functions.SaveVariable(Distribution, SavePath);
  
  SavePath = ['./Data/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i}, '.dat'];
  Functions.SaveVariable([ReviewTimeList, PageNumberList], SavePath);
end

%% Generate PDF file
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
  
  TemplateString = fileread('./Templates/RelationshipBetweenReviewTimeAndPageNumber.tex');
  TemplateString = strrep(TemplateString, '{{FileName}}', Directories{i});
  TeXFile = fopen('TempFile.tex', 'w+', 'n', 'UTF-8');
  fprintf(TeXFile, '%s', TemplateString);
  fclose(TeXFile);
  
  [~, ~] = system('xelatex TempFile.tex');
  if exist('TempFile.pdf', 'file')
    movefile('TempFile.pdf', ['./Figures/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i}, '.pdf'])
  else
    error('There is not pdf file!');
  end
end

%% Convert PDF file to PNG file
Resolution = 120;
GhostScript = 'C:\Program Files\gs\gs9.19\bin\gswin64c.exe';
if ~exist(GhostScript, 'file')
  error('There is no GhostScript!');
end
for i = 1:numel(Directories)
  disp(['Converting PDF files of ', Directories{i},' to PNG files.']);
  PDFFileName = ['Figures/ReviewTimeDistribution/', Directories{i}, '.pdf'];
  PNGFileName = ['Figures/ReviewTimeDistribution/', Directories{i}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r', num2str(Resolution), ' -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
  
  PDFFileName = ['Figures/PageNumberDistribution/', Directories{i}, '.pdf'];
  PNGFileName = ['Figures/PageNumberDistribution/', Directories{i}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r', num2str(Resolution), ' -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
  
  PDFFileName = ['Figures/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i}, '.pdf'];
  PNGFileName = ['Figures/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r', num2str(Resolution), ' -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
end

%% Generate the "Main.pdf"
disp('Generating the Main.pdf.');
[~, ~] = system('xelatex Main.tex');

%% Clear Temp File
disp('Deleting the temporary files.')
delete('*.asv');
delete('*.aux');
delete('*.fdb_latexmk');
delete('*.fls');
delete('*.synctex.gz');
delete('*.log');
delete('Figures\ReviewTimeDistribution\*.pdf');
delete('Figures\PageNumberDistribution\*.pdf');
delete('Figures\RelationshipBetweenReviewTimeAndPageNumber\*.pdf');
delete('TempFile.*');
