function N=seq2Nstruct(seq, whichFieldIsNeural, whichFieldIsCondition, ...
                       whichFieldIsMoveOnset, whichFieldIsTimes, outputBinSize)
% function N=seq2N(seq, whichFieldIsNeural, whichFieldIsCondition, whichFieldIsMoveOnset)
%
% takes an seqstruct and outputs an Nstruct, which has one entry for
% each neuron. it has the fields:
%  N(i).interpTimes.times = times in MS of each bin
%  N(i).interpTimes.moveStarts = where is moveOnset, same reference as
%     interpTimes.times indexing
%  N(i).ranges.whole - vector: min and max firing rates across all conditions
%  N(i).cond(1:C) - has one entry for each condition
%    N(i).cond(j).interpPSTH = interpolated PSTH, this is a column vector



fn = whichFieldIsNeural;
fc = whichFieldIsCondition;
fmo = whichFieldIsMoveOnset;
ft = whichFieldIsTimes;


if isempty(fc)
    conds = 1:numel(seq);
    ic = 1:numel(seq);
else
    % unique operates differently for strings and numbers
    if ischar(seq(1).(fc))
        [ conds, ia, ic ] = unique({seq.(fc)});
    else
        [ conds, ia, ic ] = unique([seq.(fc)]);
    end
end
currentTimes = seq(1).(ft);
dct = diff(currentTimes);
if numel(unique(dct)) ~= 1
    error('weird binning');
end
currDt = dct(1);

rebinMultiple = outputBinSize / currDt;
if mod(rebinMultiple, 1),
    error(['outputBinSize is not a multiple of input ' ...
           'binsize']);
end

maxTimeIndToKeep = floor(numel(currentTimes) / rebinMultiple) * rebinMultiple;


for ncond = 1:numel(conds)        % condition
    thisCondInds = find(ic==ncond);
    for itr = 1:numel(thisCondInds)         % trials within this condition
        ntr = thisCondInds(itr);
        
        tmp = full(seq(ntr).(fn)(:,1:maxTimeIndToKeep)');
        tmp = reshape(tmp, rebinMultiple, [], size(tmp,2));
        tmp = squeeze(sum(tmp,1));
        tmp = tmp / numel(thisCondInds);

        % operate over each channel
        for nchannel =  1:size(seq(1).(fn), 1) % channel
            if itr == 1
                N(nchannel).cond(ncond).interpPSTH = ...
                    tmp(:, nchannel);
                N(nchannel).cond(ncond).conditionCode = conds(ncond);
            else
                N(nchannel).cond(ncond).interpPSTH = ...
                    N(nchannel).cond(ncond).interpPSTH + tmp(:, ...
                                                             nchannel);
            end
        end
        %        disp(sprintf('condition %i, trial %i/%i', ncond, ntr, numel(thisCondInds)));
    end
    disp(sprintf('condition %i/%i', ncond, numel(conds)));
end

psthTimes = currentTimes(1:rebinMultiple:maxTimeIndToKeep);

if isempty(whichFieldIsMoveOnset)
    moveStarts = min(psthTimes);
end


for nchannel =  1:size(seq(1).(fn), 1) % channel
    N(nchannel).interpTimes.times = psthTimes;
    N(nchannel).ranges.whole = [];
    for ncond = 1:numel(conds)
        N(nchannel).ranges.whole = [N(nchannel).ranges.whole; ...
                            min(N(nchannel).cond(ncond).interpPSTH); ...
                            max(N(nchannel).cond(ncond).interpPSTH)];
    end
    N(nchannel).interpTimes.moveStarts = moveStarts;
end

