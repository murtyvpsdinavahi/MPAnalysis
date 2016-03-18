function batchDecomposeMPGAV(extractTheseIndices,electrodesToAnalyse,refChan,Max_iterations,clusterName)

% Define defaults
if ~exist('electrodesToAnalyse','var') || isempty(electrodesToAnalyse); electrodesToAnalyse = 1:64; end % Currently, we use only 64 channels
if ~exist('refChan','var') || isempty(refChan); refChan = 'Bipolar'; end
if ~exist('Max_iterations','var') || isempty(Max_iterations); Max_iterations = 100; end    
if ~exist('clusterName','var') || isempty(clusterName); clusterName = 'local'; end % Cluster for parallel computing, if any
    
[~,subjectNames,expDates,protocolNames,~,gridType,folderSourceString,capMontages] = allDataLogsForAnalysisVisualGammaEEG;
totIndex = length(extractTheseIndices);
disp(['Starting batch extraction of band power per protocol. Total indices: ' num2str(totIndex)]);

% Start the parallel pool, if any
try 
    poolObj = parpool(clusterName);
    parCompFlag = 1;
catch
    warning('Parallel pools could not be created. Parallel computing toolbox may not be installed on this copy of MATLAB; or remote computer could not be contacted.');
    parCompFlag = 0;
end

% Run MP decomposition for each subject
for iV = 1:totIndex
    
    clear iIndex
    iIndex = extractTheseIndices(iV);

    clear subjectName expDate protocolName dataLog folderName folderExtract folderLFP
    subjectName = subjectNames{iIndex};
    expDate = expDates{iIndex};
    protocolName = protocolNames{iIndex};
    capMontage = capMontages{iIndex};

    dataLog{1,2} = subjectName;
    dataLog{2,2} = gridType;
    dataLog{3,2} = expDate;
    dataLog{4,2} = protocolName;
    dataLog{14,2} = folderSourceString;

    [~,folderName,~,folderNameMP]=getFolderDetails(dataLog);
    
    disp([char(10) 'Analysing index ' num2str(iV) ' of ' num2str(totIndex)]);
    disp(['Index no.: ' num2str(iIndex)]);
    disp([subjectName expDate protocolName]);
    
    disp([refChan ' Referencing...']);
    decomposeMPPerProtocolGAV(electrodesToAnalyse,capMontage,folderName,folderNameMP,refChan,Max_iterations);

end

% Shut down parallel pool, if any
if parCompFlag 
    delete(poolObj);
end
end