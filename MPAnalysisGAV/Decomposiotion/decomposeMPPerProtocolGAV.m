function decomposeMPPerProtocolGAV(electrodesToAnalyse,gridMontage,folderName,folderNameMP,refChan,Max_iterations)

    % Define defaults
    if ~exist('refChan','var') || isempty(refChan); refChan = 'Bipolar'; end
    if ~exist('Max_iterations','var') || isempty(Max_iterations); Max_iterations = 100; end    
    
    folderExtract = fullfile(folderName,'extractedData');    
    [~,aValsUnique,eValsUnique,sValsUnique,fValsUnique,oValsUnique,cValsUnique,tValsUnique,aaValsUnique,...
        aeValsUnique,asValsUnique,aoValsUnique,avValsUnique,atValsUnique] = loadParameterCombinations(folderExtract);
    
    aLen = length(aValsUnique);
    eLen = length(eValsUnique);
    sLen = length(sValsUnique);
    fLen = length(fValsUnique);
    oLen = length(oValsUnique);
    cLen = length(cValsUnique);
    tLen = length(tValsUnique);
    aaLen = length(aaValsUnique);
    aeLen = length(aeValsUnique);
    asLen = length(asValsUnique);
    aoLen = length(aoValsUnique);
    avLen = length(avValsUnique);
    atLen = length(atValsUnique);
    
    totLen = aLen*eLen*sLen*fLen*oLen*cLen*tLen*aaLen*aeLen*asLen*aoLen*avLen*atLen;
    iLoop = 1;
    
    disp(['Total Combinations: ' num2str(totLen)]);
    hW = waitbar(0,['Calculating MP Spectrum for combination 1 of ' num2str(totLen)],'position',[465.0000  409.7500  270.0000   56.2500]);
    for a=1:aLen
        for e=1:eLen
            for s=1:sLen
                for f=1:fLen
                    for o=1:oLen
                        for c=1:cLen
                            for t=1:tLen
                                for aa=1:aaLen
                                    for ae=1:aeLen
                                        for as=1:asLen
                                            for ao=1:aoLen
                                                for av=1:avLen
                                                    for at=1:atLen                                                        
                                                        waitbar((iLoop-1)/totLen,hW,['Calculating MP Spectrum for combination ' num2str(iLoop) ' of ' num2str(totLen)]);
                                                        
                                                        % make folders
                                                        folderComb = [num2str(a) num2str(e) num2str(s) num2str(f) num2str(o) num2str(c) num2str(t) num2str(aa) num2str(ae) num2str(as) num2str(ao) num2str(av) num2str(at)];     
                                                        folderMP = [folderNameMP,'/',refChan,'/',num2str(Max_iterations),'/',folderComb,'/'];
                                                        makeDirectory(folderMP);
                                                        
                                                        % Load Data
                                                        folderLFP = fullfile(folderName,'segmentedData','LFP');
                                                        [plotData,trialNums,allBadTrials] = getDataGAV(a,e,s,f,o,c,t,aa,ae,as,ao,av,at,folderName,folderLFP,electrodesToAnalyse);
                                                        [Data,goodPos] = bipolarRef(plotData,refChan,gridMontage,trialNums,allBadTrials);
                                                        [~,timeVals] = loadlfpInfo(folderLFP);
                                                        Fs=1/(timeVals(2)-timeVals(1));       
                                                        
                                                        % Run MP Decomposition    
                                                        parDecomposeMPForData(Data,goodPos,Fs,folderMP,Max_iterations);

                                                        iLoop = iLoop + 1;
        
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    close(hW);
end
