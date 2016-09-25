%% Network_Node_Logger
%===================================================================================================
% This function logs which nodes are present within a network established
% by XBee radios.  
%---------------------------------------------------------------------------------------------------
% Author:  Skylar Cox, University of Idaho
% Date:  September 24, 2016
%---------------------------------------------------------------------------------------------------
% Dependencies:  xbee.m - available on the MATLAB file exchange from the
%                   Mathworks hardware support team.
%===================================================================================================
%% Set up

% Enter known addresses for nodes that may be on network
% nodeA = '007D33A20040D858';
% nodeB = '42007D33A20040F2';
nodeA = '0013A20040F2A915';
nodeB = '0013A20040D858AA';

numOfNodes = 2;


% Identify com port that coordinator node is using
xb = xbee('COM5');  

% Check parameters of coordinator radio
getLocalParameters(xb)

% setPinMode(xb, 20, 'analogInput')
% setPinMode(xb, 19, 'analogInput')

% Set duration of data logging
searchTime = 500;  % [sec], Duration of test
pingWait   = 2;   % [sec], Time to wait between pings

% Estimate number of pings that will occur during testing
numOfPings = floor(searchTime/(2.5*pingWait + 3));

% Initialize variables
nodeAdresses = cell(numOfPings,1);
checkTime    = cell(numOfPings,1);
nodesInNet   = zeros(numOfPings,1);
nodeNames    = cell(numOfPings,2);

%% Time loop for discovering nodes within the network

for iDscvr = 1:numOfPings
    % Discover network nodes and record info
    nodeAdresses{iDscvr,1} = discoverNetwork(xb);
    checkTime{iDscvr,1}    = datestr(now);
    nodesInNet(iDscvr,1)   = numel(nodeAdresses{iDscvr,1});
    
    % Log A if ismember
    if ismember(nodeA,nodeAdresses{iDscvr})
        nodeNames{iDscvr,1} = 'A';
        %readVoltage(xb, 19, nodeA)
    end
    
    % Log B if ismember
    if ismember(nodeB,nodeAdresses{iDscvr})
        nodeNames{iDscvr,2} = 'B';
        %readVoltage(xb, 19, nodeB)
    end
    
    % Output status message
    fprintf('Ping %d of %d:  %d nodes found at %s.\n',iDscvr,numOfPings,nodesInNet(iDscvr,1),checkTime{iDscvr,1});
    
    % Set ping pause
    pause(pingWait);
end

%% Reporting cell matrix

% Compile reporting information
reportCell = cell(numOfPings,numOfNodes+2);
for iUp = 1:numOfPings
    reportCell(iUp,:) = {checkTime{iUp},nodesInNet(iUp,1),nodeNames{iUp,:}};
end

%===================================================================================================
%                           END
%===================================================================================================