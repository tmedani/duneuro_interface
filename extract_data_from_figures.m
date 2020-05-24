function data = extract_data_from_figures(filename)
%%
% 
% Input  : File name <filename.fig> 
%          with multiple plots in a single file
% Output : struct data
%        : data.names  contains names of the display object Yvalues
%        : data.Y      contains the actual plot values withthe first column
%                      containing the x-values
%
% Written by Chetanya Puri, 2019
% Last Modified: Nov 6, 2019
%
fig = openfig(filename); % Open figure and assign it to fig object
dataObjs = findobj(fig,'-property','YData'); % Find all graphic objects with YData, in our case line values
xval        = dataObjs(1).XData; % Find the X-axis value
Ymat = [xval(:)]; % Create a matrix with first column of x values
for i=1:length(dataObjs)
    legend_name{i,1} = dataObjs(i).DisplayName;
    yval        = dataObjs(i).YData;
    Ymat = [Ymat yval(:)]; % Keep appending column vectors
end
close(fig); % close the figure
data.names = ['X';legend_name]; 
data.Y = Ymat;
end