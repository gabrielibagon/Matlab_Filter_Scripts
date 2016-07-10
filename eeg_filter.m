% Basic EEG pre-processing
%
% USAGE:
% >> output_matrix = eeg_filter(eeg_matrix,lowcut, highcut)
%
%
% To input a txt or csv file into a matrix, use the commands:
%
% >> M = csvread(filename, start_row, start_column);
%
% Read more commands: http://www.mathworks.com/help/matlab/ref/csvread.htm
%
%
% If data is from 16-channel OpenBCI board (non-SD), then output file needs to be
% adjusted for 125Hz sampling rate.
% Use the commands:
%
% >> clear M1, clear M2
% >> for x = 1:length(original(:,1))
% >>   if mod(x,2)==1
% >>     M1(x,:) = {original(x,:)};
% >> end
% >> end
% >> M2 = cell2mat(M1);         %this is the output array w/ no duplicates
%
%
% To output filtered data to a file, use the following commands (copy %8.8f' for ]
% every column in your file):
% >> fid = fopen('name_of_output.txt', 'wt'); 
% >> fprinft(fid, '%8.8f\n', M1);
% >> fclose(fid);
%

%function call
function [filtered_file] = eeg_filter(eeg_data, f_low, f_high, Hz)
% declare constants
fs = Hz;               %sampling rate
fn = fs/2;              %Nyquist frequency
filter_order = 2;       %this is what Chip uses
disp('hello world')
%% Filter design
% Notch window
wn = [59 61];            % Cutoff frequencies
% 2nd order Butterworth filters
[b,a]=butter(filter_order,f_high/(fs/2),'low');      % Low pass filter coefficients
[b1,a1]=butter(filter_order,f_low/(fs/2),'high');    % High pass filter coefficients
[bn,an] = butter(filter_order,wn/(fs/2),'stop');     % Notch filter coefficients
filtered_file = [];
for i = 1:length(eeg_data(1,:))
    channel = eeg_data(:,i);            % isolate the channel
    y = filtfilt(bn,an,channel);        % notch filter
    y = filtfilt(b1,a1,y);              % high pass filter
    y = filtfilt(b,a,y);                % low pass filter
    filtered_file = [filtered_file y];
end
