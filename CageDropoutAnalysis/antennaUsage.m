function antennaUsage(ns6FileName)
% antennaUsage(filename)
% 
% Looks through which antennas we're using in the cage, based on the new
% firmware that Blackrock has provided.
%
% We'll have to see whether we can get it to figure out which version of
% the firmware we're using automatically.
% 
% From blackrock: 
% Versions of the firmware:
% 1. v3 Original Ch96 
% 2. v4 With Ch96 Bit 15-13 Antenna bit (3bits)
% 3. v5 With Ch96 Bit 15-13 Antenna bit (3bits), Bit 12 1'b0, Bit 11-4 LOL/LED data (8bits), Bit 3-1 3'b000
% 
% Note:
% 1. Antenna bits (3bits) (indicates which antenna data is being selected):
% //Ant1 Ant[2:0]<=000;
% //Ant2 Ant[2:0]<=001;
% //Ant3 Ant[2:0]<=010;
% //Ant4 Ant[2:0]<=011;
% //Ant5 Ant[2:0]<=100;
% //Ant6 Ant[2:0]<=101;
% //Ant7 Ant[2:0]<=110;
% //Ant8 Ant[2:0]<=111;
% 
% 2. LOL/LED data (8bits) (loss of lock, or receiver front panel blue LED indicators)
% //LOL[7:0] = {LED8,LED7,LED6,LED5,LED4,LED3,LED2,LED1}
%% filename parsing
if ~exist('filename','var')
    ns6FileName = '';
end

if ~exist('filename','file')
    [ns6FileName,ns6Path] = uigetfile('.\*.ns6','Select a 30k file')
    ns6FileName = [ns6Path,filesep,ns6FileName];
end

%% load file
% using a modified version of openNSx to allow us to import uint16 instead
% of int16. This is a stupid pain, but attempting to read a raw input from
% the ns6 file looks way worse
nsSix = openNSx_KB(ns6FileName,'precision','uint16');



antInd = [nsSix.ElectrodesInfo.ElectrodeID] == 96; % we want channel 96
% for some reason pre-2020 matlab doesn't play well with signed
% integers and bitwise operation, so we have to typecast the int16 as a
% uint16. whee
antStream = nsSix.Data(antInd,:);


%% parse out the datastream
% for firmware v5 we get both which antenna was used and which antennas
% were even seeing the data
antUse = uint16(nan(size(antStream))); % which antenna are we using for the signal?
antConnect = uint16(nan(8,length(antStream))); % which antennas are connected?
validStream = nan(size(antStream)); % double check that the data stream looks legitimate
validFlags = 2^12+sum(2.^[1:3]);



for ii = 1:length(antStream)
    % which antenna are we using? bits 13-15 == antenna#
    antUse = bitshift(antStream(ii),-13);
    antUse = bitand(uint16(7),antUse)+1;
    
    frame = bitshift(antStream(ii),-4); % caring about bits 3-10 (4-11 per ming)
    for jj = 1:8
        antConnect(jj,ii) = any(bitand(antStream(ii),uint16(2^(jj-1))));
    end
    validStream(ii) = ~any(bitand(validFlags,antStream(ii))); % look for bits that _should_ be zero
end