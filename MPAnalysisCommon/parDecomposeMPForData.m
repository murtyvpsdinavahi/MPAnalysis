function parDecomposeMPForData(Data,goodPos,Fs,folderMP,Max_iterations)

    % Define defaults
    if ~exist('Max_iterations','var') || isempty(Max_iterations); Max_iterations = 100; end    
    
    %%%%%%%%%%%%%%%%%%% Perform MP for each electrode %%%%%%%%%%%%%%%%%%%%%
    [totElecs,~,L] = size(Data);
    
    % Slice data for faster performance
    slicedData = cell(1,totElecs);
    for electrodeNum = 1:totElecs
        slicedData{electrodeNum} = squeeze(Data(electrodeNum,goodPos{electrodeNum},:));
    end
    clear electrodeNum
            
    parfor electrodeNum = 1:totElecs
        disp(['electrode: ' num2str(electrodeNum)])
        tag = ['elec' num2str(electrodeNum)];   
        data = squeeze(slicedData{electrodeNum});

        % Import data
        importData(data',folderMP,tag,[1 L],Fs);

        % Perform Gabor decomposition
        runGabor(folderMP,tag,L,Max_iterations);        
    end   
end