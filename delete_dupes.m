% Script designed to remove duplicate samples from data recorded from the
% 16-channel OpenBCI board. The OpenBCI board sends samples at 250Hz, but
% while streaming 16 channels over bluetooth, only 8 channels send new data at a
% time (effectively halving the sample rate). Thus, the output file will
% contain duplicate samples (which channels have new vs. old data for each
% particular channel alternates for every other sample).
% 
% Run this file 


% >> clear M1, clear M2
% >> for x = 1:length(original(:,1))
% >>   if mod(x,2)==1
% >>     M1(x,:) = {original(x,:)};
% >> end
% >> end
% >> M2 = cell2mat(M1);         %this is the output array w/ no duplicates

%function call
function [new_data] = delete_dupes(data)

clear M1, clear M2, clear board, clear daisy;
board = data(:,1:8);
daisy = data(:,9:16);
for x = 1:length(board(:,1))
    if mod(x,2) == 0
        M1(x,:) = {board(x,:)};
    end
end
board_fixed = cell2mat(M1);

for x = 1:length(daisy(1:end-1,1))
    if mod(x,2) == 1
        M2(x,:) = {daisy(x,:)};
    end
end
daisy_fixed = cell2mat(M2);

% clear M1, clear M2, clear board, clear daisy

new_data = [board_fixed daisy_fixed];



     
        
