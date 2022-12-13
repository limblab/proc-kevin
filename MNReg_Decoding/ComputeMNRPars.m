function DPars = ComputeMNRPars(NCell,XCell,dt)
% SUPPORT FUNCTION to compute multinomial regression parameters from calibration data
%
% DPars = ComputeVKFPars(NCell,XCell,dt)
%
% NCell and XCell will have all the samples of the state and neural data,
% each separated into a cell corrisponding to their calibration trial. 
%
%
% DPars output is a struct of decoder parameters, 
% mnrModel:         function handle to evaluate the multinomial regression
%                   model, mnrModel(firingrate,A,b)
% A:                Mapping matrix from neurons to categories for mnrModel.
% CatList:          List of all categories names predicted by mnrModel and
%                   their associated velocity commands
% speedScale:       How much to scale speeds defiend in CatList.
% mixCat:           How much to blend each category when not predicting
%                   probability 1 for a given category.
% dt:               Timestep.
%
%
%
%
%
% ZC Danziger Jul 2022
%
% Edits:
% P Alcolea Aug 2022: a) Removed dropconstantrows neural network
% preprocessing to avoid dimensional inconsistency errors when training the
% decoder and some neurons do not fire.
%

%% Stack N and X into [obs x neurons] and [obs x state] matrices
N = cell2mat(NCell);
X = cell2mat(XCell); 
ns = size(X,1);     % number of samples


%% Prepare parameters for the decoder and categories
% overall speed of the categories
speedScale = 0.7;   % ~mean of forced cursor velocity
% category mixing coefficient (online use only)
mixCat = 0.85;
% list of possible categories into which to classify all states, listed as
% [cardinal direction][fast/slow/rest]
% CatList = {'Nf', [0 1];
%            'Ef', [1 0];
%            'Sf', [0 -1];
%            'Wf', [-1 0];
%            'Or', [0 0];
%            'Cr', [0 0] };
CatList = {'Nf', [0 1];
           'Ns', [0 0.5];
           'Ef', [1 0];
           'Es', [0.5 0];
           'Sf', [0 -1];
           'Ss', [0 -0.5];
           'Wf', [-1 0];
           'Ws', [-0.5 0];
           'Cr', [0 0] };




%% Partition state information into target categories
% divide each trial into segments for categorization
% (hard coded for if/else ladder divisions)
trialDiv = 5;
% all distances from center
distFromCntr = sqrt(sum(X(:,1:2).^2,2));    
% the trialDiv divisions at which this distance is categorized
[~, ~, bin] = histcounts(distFromCntr,linspace(0,max(distFromCntr),trialDiv+1));

% assign each sample to a category
targetCat = cell(ns,1);
for k=1:ns
    if bin(k)==1
        % resting in center
        targetCat{k} = 'Cr';
    elseif bin(k)==5 && X(k,2)>0
        % stoping on north target
        targetCat{k} = 'Ns'; %'Or';
    elseif bin(k)==3 && X(k,2)>0
        % fast speed moving north
        targetCat{k} = 'Nf';
    elseif (bin(k)==2 || bin(k)==4) && X(k,2)>0
        % slow speed moving north
        targetCat{k} = 'Ns'; %'Nf';
    elseif bin(k)==5 && X(k,1)>0
        % stoping on east target
        targetCat{k} = 'Es'; %'Or';
    elseif bin(k)==3 && X(k,1)>0
        % fast speed moving east
        targetCat{k} = 'Ef';
    elseif (bin(k)==2 || bin(k)==4) && X(k,1)>0
        % slow speed moving east
        targetCat{k} = 'Es'; %'Ef';
    elseif bin(k)==5 && X(k,2)<0
        % stoping on south target
        targetCat{k} = 'Ss'; %'Or';
    elseif bin(k)==3 && X(k,2)<0
        % fast speed moving south
        targetCat{k} = 'Sf';
    elseif (bin(k)==2 || bin(k)==4) && X(k,2)<0
        % slow speed moving south
        targetCat{k} = 'Ss'; %'Sf';
    elseif bin(k)==5 && X(k,1)<0
        % stoping on west target
        targetCat{k} = 'Ws'; %'Or';
    elseif bin(k)==3 && X(k,1)<0
        % fast speed moving west
        targetCat{k} = 'Wf';
    elseif (bin(k)==2 || bin(k)==4) && X(k,1)<0
        % slow speed moving west
        targetCat{k} = 'Ws'; %'Wf';
    end

end


%% Compute multinomial regression to velocity categories
% translate human-readible categories into category numbers
CatListIX = cellfun(@(u) find(strcmp(u,CatList(:,1))),targetCat);

% solve the multinomial regression problem with ANNs (since mnrfit is slow)
% swap category list into ANN target arrangement
targs = zeros(size(CatList,1),length(CatListIX));
for k=1:length(CatListIX), targs(CatListIX(k),k) = 1; end
% net setup
softNet = PrepareSoftNet(size(N,2));

% train
softNet = train(softNet,N',targs);

% reproduce results by hand for export [softmax( W2*(W1*u+b1)+b2 )]
A0 = softNet.LW{2,1}*softNet.IW{1};             % parameter mapping matrix
b = softNet.LW{2,1}*softNet.b{1}+softNet.b{2};  % offset
A = [A0, b];                                    % merge for representation compactness
mnrModel = @(u,A) softmax(A*[u; 1], []);


% % solve multinomial regression (too slow)
% [A, dev, stats] = mnrfitZCD(N,CatListIX,'maxiterations',5);



%% Consolidate output decoder parameters
% construct a struct of parameters compatible with the
% MultinomialSelection.m function used for state prediction.
DPars.mnrModel = mnrModel;
DPars.A = A;
DPars.CatList = CatList;
DPars.speedScale = speedScale;          % online use only
DPars.mixCat = mixCat;                  % online use only
DPars.dt = dt;                          % online use only


end




function net = PrepareSoftNet(layerSize)

net = patternnet(layerSize);                            % establishes softmax on the end
net.divideFcn = 'dividetrain';                          % everything for training
net.layers{1}.transferFcn = 'purelin';                  % everything is linear, like GLM
net.inputs{1}.processFcns = {'fixunknowns'};            % get rid of preprocessing
net.outputs{2}.processFcns = {'fixunknowns'};           % get rid of post-processing
net.name = 'Multinomial Velocity Neural Decoder';
net.trainParam.showWindow = false;                      % supress training GUI

% set up special weight initializations since we are using purelin
net.initFcn = 'initlay';
for i=1:length(net.layers)
    net.layers{i}.initFcn  = 'initwb';
    net.biases{i}.initFcn  = 'randsmall';
    for j=1:size(net.inputWeights,2)
        net.inputWeights{i,j}.initFcn = 'randsmall';
    end
end



end

