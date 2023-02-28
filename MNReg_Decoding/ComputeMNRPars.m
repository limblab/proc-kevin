function DPars = ComputeMNRPars(Neur_Cell,Vel_Cell,dt,plt_flag)
% SUPPORT FUNCTION to compute multinomial regression parameters from calibration data
%
% DPars = ComputeMNPars(Neur_Cell, Pos_Cell, dt, varargin)
%
% Neur_Cell and Pos_Cell will have all the samples of the state and neural data,
% each separated into a cell corrisponding to their calibration trial. 
%
% varargin:         We can either have the categories input, or the number
%                   of categories per velocity direction. 
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
% plt_flag:             if plot is on, will plot the velocities with color
%                   based on state
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
% K Bodkin Dec 2022:
%       1. Changing the loading process to allow different trial lengths
%       2. Updating state classification definition to be the actual
%           velocity

%% Stack N and X into [obs x neurons] and [obs x state] matrices
Neur = cell2mat(Neur_Cell);
Vel = cell2mat(Vel_Cell); 
ns = size(Vel,1);     % number of samples


%% Prepare parameters for the decoder and categories
% overall speed of the categories
speedScale = 0.7;   % ~mean of forced cursor velocity
% category mixing coefficient (online use only)
mixCat = 0.85;



%% Partition state information into target categories
% We'll just use the velocity of the cursor, and divide into the number of
% planned 

% num_dirs = 8; % for 8 target directions
% dir_splits = 2; % number of states (speeds) per direction
% 
% for varg_i  = 1:2:numel(varargin)
%     if strcmpi(varargin{varg_i},'num_dirs')
%         num_dirs = varargin{varg_i+1};
%     elseif strcmpi(varargin{varg_i},'dir_splits')
%         dir_splits = varargin{varg_i+1};
%     end
% end

% start with x only, to make the coding faster
quants = quantile(Vel(:,1),[.01, .05, .95, .99]); % divide the x velocity
class_def = [quants(1:2),0,quants(3:4)]; % create the classes
class_compare = repmat(class_def,size(Vel,1),1); % for categorizing each sample

% classify each sample
[~,CatListIx] = min(abs(repmat(Vel(:,1),1,5)-class_compare),[],2); % categorize the samples

% create the one-hot array for each sample
targs = zeros(size(class_compare));
for ind = 1:size(CatListIx,1)
    targs(ind,CatListIx(ind)) = 1;
end

% create the CatList for classification later on.
CatList = cell(5,2);
for ii = 1:5
    CatList{ii,1} = ii;
    CatList{ii,2} = [class_def(ii),0];
end


% Plot if flag is on
if plt_flag
    cl = lines;
    scatter(1:length(Vel(:,1)), Vel(:,1), 1, cl(CatListIx,:));
end


%% Compute multinomial regression to velocity categories
% % translate human-readible categories into category numbers
% CatListIX = cellfun(@(u) find(strcmp(u,CatList(:,1))),targetCat);

% % solve the multinomial regression problem with ANNs (since mnrfit is slow)
% % swap category list into ANN target arrangement
% targs = zeros(size(CatList,1),length(CatListIX));
% for k=1:length(CatListIX), targs(CatListIX(k),k) = 1; end


% net setup
softNet = PrepareSoftNet(size(Neur,2));

% train
softNet = train(softNet,Neur',targs');

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

