%%% PARAMETERS TO SPECIFY
% 'filename' = filename (string)
%  'start_row' = first row of interest in file (int)
% 'end_row' = last row of interest in file (int)
% 'start_column' = first column of interest in file (int)
% 'end_column' = last column of interest in file (int)
% 'low_cutoff' = low cutoff of notch (int)
% 'high_cutoff' = high cutoff of notch (int)



filtered_file = [];				% matrix to hold filtered data
fs = 250;						% sampling rate
fn = fs/2						% Nyquist frequency
raw_file = csvread(filename);	% read csv to and put in matrix
raw_file = raw_file[start_row:end_row, start_column:end_column]; %crop to necessary columns
for i = 1:length(M(1,1:end))				%iterate through 
	channel = raw_file(1:end,i);

	%Notch
	f0 = 60;					% notch frequency
	freqRatio = f0/fn 			% ratio of notchfreq/nyquist
	notchWidth = 0.1;			% notch width
	%Notch zeros
	notchZeros = [exp( sqrt(-1)*pi*freqRatio ),exp(-sqrt(-1)*pi*freqRatio )];
	%Notch poles
	notchPoles = (1-notchWidth)*notchZeros;

	b=poly(notchZeros);
	a=poly(notchPoles);

	%notch signal x
	y = filter(b,a,channel);

	%bandpass
	cutoff = [low_cutoff,high_cutoff];
	order = 2;
	[b,a] = butter(order, cutoff/fn, 'bandpass');
    y = filter(b,a,y);
    filtered_file = [filtered_file;y]
