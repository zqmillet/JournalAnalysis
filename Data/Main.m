Directories = {'AnnualReviewsInControl', ...
               'ProceedingsOfTheIEEE', ...
               'IEEETransactionOnIndustrialElectronics', ...
               'IEEETransactionOnIndustrialInformatics', ...
               'IEEETransactionOnInformationForensicsAndSecurity', ...
               'SafetyScience'};

for i = 1:numel(Directories)          
    Data = importdata(['./Journals/', Directories{i},'/References.dat']);

    KeyList = Data.textdata;
    ReviewTimeList = Data.data(:, 1);
    PageNumberList = Data.data(:, 2) + 1;

    Distribution = Functions.GetDensityByStep(ReviewTimeList, 10);
    SavePath = ['./OutputData/', Directories{i}, 'ReviewTimeDistribution.dat'];
    save(SavePath, '-ascii', 'Distribution');
    figure;
    bar(Distribution(:, 1), Distribution(:, 2));
    title(['Review Time Distribution of ', Directories{i}]);
    xlabel('Review Time (Day)');
    ylabel('Paper Number');
    
    Distribution = Functions.GetDensityByStep(PageNumberList, 1);
    SavePath = ['./OutputData/', Directories{i}, 'PageNumberDistribution.dat'];
    save(SavePath, '-ascii', 'Distribution');
    figure;
    bar(Distribution(:, 1), Distribution(:, 2));
    title(['Page Number Distribution of ', Directories{i}]);
    xlabel('Page Number');
    ylabel('Paper Number');
    
    disp(Directories{i});
    disp(['  The maximum review Time is ', num2str(max(ReviewTimeList)), ' days,']);
    disp(['  The average review Time is ', num2str(mean(ReviewTimeList)), ' days,']);
    disp(['  The minimum review Time is ', num2str(min(ReviewTimeList)), ' days.']);
    disp(['  The maximum page number is ', num2str(max(PageNumberList)), ',']);
    disp(['  The average page number is ', num2str(mean(PageNumberList)), ',']);
    disp(['  The minimum page number is ', num2str(min(PageNumberList)), '.']);
end