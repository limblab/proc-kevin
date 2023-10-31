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
% plt_flag:         if plot is on, will plot the velocities with color
%                   based on state and a confusion matrix
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
%       2. Updating state classification definition to work off the
%           velocity provided. 
%       3. Adding plotting abilities: classified state, predicted state,
%           confusion matrix
%
% K Bodkin Feb 2022
%       1. 2D states, completely orthogonal for now

%% Stack N and X into [obs x neurons] and [obs x state] matrices
Neur = cell2mat(Neur_Cell);
Vel = cell2mat(Vel_Cell); 
ns = size(Vel,1);     % number of samples


%% Prepare parameters for the decoder and categories
% overall speed of the categories
speedScale = 1.4;   % ~mean of forced cursor velocity
% category mixing coefficient (online use only)
mixCat = 0.85;



%% Partition state information into target categories
% We'll just use the velocity of the cursor, and divide into the number of
% planned 

% Normalize the data to account for faster flexion/ulnar movements
% Current normalization strategy : 
%   - Normalize each direction by the 95th quantile FOR THAT DIRECTION
%       (So that the "zero movement" condition doesn't get shifted)
%   - Everything over the 95th quantile is also capped at 1

% left
left_idx = find(Vel(:,1) < 0);
left_95 = quantile(Vel(left_idx,1),.05); % find everything going left
Vel(left_idx,1) = -Vel(left_idx,1)/left_95; % divide by 95th quantile

% right
right_idx = find(Vel(:,1) > 0);
right_95 = quantile(Vel(right_idx,1),.95); % find everything going right
Vel(right_idx,1) = Vel(right_idx,1)/right_95; % divide by 95th quantile

% up
up_idx = find(Vel(:,2) > 0);
up_95 = quantile(Vel(up_idx,2),.95); % find everything going up
Vel(up_idx,2) = Vel(up_idx,2)/up_95; % divide by 95th quantile

% down
down_idx = find(Vel(:,2) < 0);
down_95 = quantile(Vel(down_idx,2),.05); % find everything going down
Vel(down_idx,2) = -Vel(down_idx,2)/down_95; % divide by 95th quantile



% Nine classes -- two for each direction, plus a "no-movement" condition
% CatList == category definitions with labels, for predictions. Not
% normalized
% cat_def == category definitions as a matrix, normalized

% CatList = { 'zero', [ 0,0];    ... % no movement
%             'fast right', [.75 * right_95,0];    ... % fast right
%             ' slow right', [.3 * right_95,0];   ... % slow right
%             'fast left', [.75 * left_95,0];   ... % fast left
%             'slow left', [.3 * left_95,0];  ... % slow left
%             'fast up', [0,.75*up_95];    ... % fast up
%             'slow up', [0,.3*up_95];   ... % slow up
%             'fast down', [0,.75*down_95];   ... % fast down
%             'slow down', [0,.3*down_95]};     % slow down\

%change the threshold for velocity categories
CatList = { 'zero', [ 0,0];    ... % no movement
            'fast right', [.45 * right_95,0];    ... % fast right
            ' slow right', [.1 * right_95,0];   ... % slow right
            'fast left', [.45 * left_95,0];   ... % fast left
            'slow left', [.1 * left_95,0];  ... % slow left
            'fast up', [0,.45*up_95];    ... % fast up
            'slow up', [0,.1*up_95];   ... % slow up
            'fast down', [0,.45*down_95];   ... % fast down
            'slow down', [0,.1*down_95]};     % slow down\        
 
cat_def = [ 0,0;    ... % no movement
          .45,0;    ... % fast right
          .1,0;   ... % slow right
          -.45,0;   ... % fast left
          -.1,0;  ... % slow left
          0,.45;    ... % fast up
          0,.1;   ... % slow up
          0,-.45;   ... % fast down
          0,-.1];     % slow down\


% classify each sample and create the one-hot matrix
% cats == category for each sample
% targs == one-hot matrix; the training target for the multinom. regression
cats = zeros(size(Vel,1),1);
targs = zeros(size(Vel,1),size(cat_def,1));
for ii = 1:length(cats)
    [~,cats(ii)] = min(sum((Vel(ii,:)-cat_def).^2,2)); % minimum distance from category
    targs(ii,cats(ii)) = 1;
end




%% Compute multinomial regression to velocity categories

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
% [A, dev, stats] = mnrfitZCD(N,classes,'maxiterations',5);




%% Consolidate output decoder parameters
% construct a struct of parameters compatible with the
% MultinomialSelection.m function used for state prediction.
DPars.mnrModel = mnrModel;
DPars.A = A;
DPars.CatList = CatList;
DPars.speedScale = speedScale;          % online use only
DPars.mixCat = mixCat;                  % online use only
DPars.dt = dt;                          % online use only


%% Plot 
% Plot if flag is on
if plt_flag
    for ii = 1:length(Neur)
      [~,predict_state(ii)] = max(DPars.mnrModel(Neur(ii,:)',DPars.A)); % plot it
    end
    
    % Velocities in time
    cl = lines;
    f = figure;
    ax(1) = subplot(2,1,1);
    scatter((1:length(Vel(:,1)))*dt, Vel(:,1), 2, cl(cats,:));
    ylabel('Velocity')
    title('Input Labels')
    ax(2) = subplot(2,1,2); 
    scatter((1:length(Vel(:,1)))*dt, Vel(:,1), 2, cl(predict_state,:));
    ylabel('Velocity')
    xlabel('Time')
    title('Predicted Labels')
    linkaxes(ax,'x')
    
    % Confustion matrix
    figure
    cm = confusionchart(CatList(cats), CatList(predict_state)');
    cm.Title = 'Confusion Matrix of training velocity state';
    cm.RowSummary = 'row-normalized';
    cm.ColumnSummary = 'column-normalized';
end


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

