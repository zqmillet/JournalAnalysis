% This script is used to generate the figures in the folder "Figures", which are used in "Readme.md" file, and the "Main.pdf" file.
% If you modify the raw data in the folder "Journals", please run this script to regenerate all the figures and the "Main.pdf" file. 
% Runtime Environment:
%  - Windown 10,
%  - Matlab 2016a,
%  - TeX Live 2015,
%  - GhostScript 9.19.

%% Set the directories
Directories = { ...  
  'ProceedingsOfTheIEEE', 'POTI'; ...
  'IEEETransactionOnIndustrialElectronics', 'TIE'; ...
  'IEEETransactionOnIndustrialInformatics', 'TII'; ...
  'IEEETransactionOnInformationForensicsAndSecurity', 'TIFS'; ...
  'SafetyScience', 'SS'; ...
  'AnnualReviewsInControl', 'ARIC'...
};

Dictionary = containers.Map;

%% Handle the raw data
for i = 1:size(Directories, 1)          
  Data = importdata(['./Journals/', Directories{i, 1},'/References.dat']);

  KeyList = Data.textdata;
  ReviewTimeList = Data.data(:, 1);
  PageNumberList = Data.data(:, 2) + 1;
  
  Dictionary([Directories{i, 2}, 'MINRT']) = num2str(min(ReviewTimeList));
  Dictionary([Directories{i, 2}, 'AVERT']) = num2str(mean(ReviewTimeList));
  Dictionary([Directories{i, 2}, 'MAXRT']) = num2str(max(ReviewTimeList));
  Dictionary([Directories{i, 2}, 'MINPN']) = num2str(min(PageNumberList));
  Dictionary([Directories{i, 2}, 'AVEPN']) = num2str(mean(PageNumberList));
  Dictionary([Directories{i, 2}, 'MAXPN']) = num2str(max(PageNumberList));
  
  disp(['Handling the data of ', Directories{i, 1}, '.']);
  Distribution = Functions.GetDistribution(ReviewTimeList, 15);
  SavePath = ['./Data/ReviewTimeDistribution/', Directories{i, 1}, '.dat'];
  Functions.SaveVariable(Distribution, SavePath);

  Distribution = Functions.GetDistribution(PageNumberList, 10);
  SavePath = ['./Data/PageNumberDistribution/', Directories{i, 1}, '.dat'];
	Functions.SaveVariable(Distribution, SavePath);
  
  SavePath = ['./Data/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i, 1}, '.dat'];
  Functions.SaveVariable([ReviewTimeList, PageNumberList], SavePath);
end

%% Generate the Readme.md file
TemplateString = fileread('./Templates/Readme.tmp');
Keys = Dictionary.keys;
for i = 1:numel(Keys)
  Key = ['{{', Keys{i}, '}}'];
  TemplateString = strrep(TemplateString, Key, Dictionary(Keys{i}));
end
ReadmeFile = fopen('Readme.md', 'w+', 'n', 'UTF-8');
fprintf(ReadmeFile, '%s', TemplateString);
fclose(ReadmeFile);

%% Generate PDF file
for i = 1:size(Directories, 1) 
  TemplateString = fileread('./Templates/ReviewTimeDistribution.tmp');
  TemplateString = strrep(TemplateString, '{{FileName}}', Directories{i, 1});
  TeXFile = fopen('TempFile.tex', 'w+', 'n', 'UTF-8');
  fprintf(TeXFile, '%s', TemplateString);
  fclose(TeXFile);
  
  disp(['Generating the PDF files of ', Directories{i, 1}, '.']);
  [~, ~] = system('xelatex TempFile.tex');
  if exist('TempFile.pdf', 'file')
    movefile('TempFile.pdf', ['./Figures/ReviewTimeDistribution/', Directories{i, 1}, '.pdf'])
  else
    error('There is not pdf file!');
  end
  
  TemplateString = fileread('./Templates/PageNumberDistribution.tmp');
  TemplateString = strrep(TemplateString, '{{FileName}}', Directories{i, 1});
  TeXFile = fopen('TempFile.tex', 'w+', 'n', 'UTF-8');
  fprintf(TeXFile, '%s', TemplateString);
  fclose(TeXFile);
  
  [~, ~] = system('xelatex TempFile.tex');
  if exist('TempFile.pdf', 'file')
    movefile('TempFile.pdf', ['./Figures/PageNumberDistribution/', Directories{i, 1}, '.pdf'])
  else
    error('There is not pdf file!');
  end
  
  TemplateString = fileread('./Templates/RelationshipBetweenReviewTimeAndPageNumber.tmp');
  TemplateString = strrep(TemplateString, '{{FileName}}', Directories{i, 1});
  TeXFile = fopen('TempFile.tex', 'w+', 'n', 'UTF-8');
  fprintf(TeXFile, '%s', TemplateString);
  fclose(TeXFile);
  
  [~, ~] = system('xelatex TempFile.tex');
  if exist('TempFile.pdf', 'file')
    movefile('TempFile.pdf', ['./Figures/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i, 1}, '.pdf'])
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
for i = 1:size(Directories, 1) 
  disp(['Converting PDF files of ', Directories{i, 1},' to PNG files.']);
  PDFFileName = ['Figures/ReviewTimeDistribution/', Directories{i, 1}, '.pdf'];
  PNGFileName = ['Figures/ReviewTimeDistribution/', Directories{i, 1}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r', num2str(Resolution), ' -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
  
  PDFFileName = ['Figures/PageNumberDistribution/', Directories{i, 1}, '.pdf'];
  PNGFileName = ['Figures/PageNumberDistribution/', Directories{i, 1}, '.png'];
  Parameters = ['-sDEVICE=pngalpha -dBATCH -sOutputFile=', PNGFileName, ' -r', num2str(Resolution), ' -dNOPAUSE'];
  if ~exist(PDFFileName, 'file');
    disp('File does not exist!');
    continue;
  end  
  Command = ['"', GhostScript, '" ', Parameters, ' ', PDFFileName];
  [~, ~] = system(Command);
  
  PDFFileName = ['Figures/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i, 1}, '.pdf'];
  PNGFileName = ['Figures/RelationshipBetweenReviewTimeAndPageNumber/', Directories{i, 1}, '.png'];
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
