% % MIT License
% % 
% % Copyright (c) 2016 ISEA, Heiko Witzenhausen
% % 
% % Permission is hereby granted, free of charge, to any person obtaining a copy
% % of this software and associated documentation files (the "Software"), to deal
% % in the Software without restriction, including without limitation the rights
% % to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% % copies of the Software, and to permit persons to whom the Software is
% % furnished to do so, subject to the following conditions:
% % 
% % The above copyright notice and this permission notice shall be included in all
% % copies or substantial portions of the Software. The Text "Developed by ISEA @ RWTH Aachen" 
% % may not be removed from the graphical user interface.
% % 
% % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% % IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% % FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% % AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% % LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% % OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% % SOFTWARE.
% % 


function [ output_args ] = ReducePlotData( resolution )
%REDUCEPLOTDATA Summary of this function goes here
%   Detailed explanation goes here

	optimizationDuration = tic();
	
	switch nargin
		case 0
			resolution = 0.001;
	end

	axes.handles = get(gcf, 'Children');
	
	for axesNumber = 1:length(axes.handles)
		ax = axes.handles(axesNumber);
		plotObjects = get(ax, 'Children');

% 		data.ax.xlim = get(ax, 'XLim');
		data.ax.ylim = get(ax, 'YLim');
% 		data.ax.xsize = data.ax.xlim(2)-data.ax.xlim(1);
		data.ax.ysize = data.ax.ylim(2)-data.ax.ylim(1);

		for objectNumber = 1:length(plotObjects)
			object = plotObjects(objectNumber);
			if ~max(strcmp(get(object, 'Type'), {'line','patch'}))
				continue;
			end;
			
			if (strcmp(get(object, 'LineStyle'), 'none') && ~(strcmp(get(object, 'Type'), 'patch')))		% Rein als Punkte geplottete Linien werden nicht reduziert
				continue;
			end;

			data.x = get(object, 'XData');
			data.y = get(object, 'YData');
			
			lengthBefore = length(data.x);

				deleteList = [];
				lastUndeleted = 1;
				for i = 2:length(data.x)-1;
					y = linFunction(data.x(lastUndeleted), data.y(lastUndeleted), data.x(i+1), data.y(i+1), data.x(lastUndeleted+1:i));
					if(max(abs(y - data.y(lastUndeleted+1:i))) < resolution*data.ax.ysize)
						deleteList = [deleteList; i];
					else
						lastUndeleted = i;
					end;
				end;	

				data.x(deleteList) = [];
				data.y(deleteList) = [];	
				
			lengthAfter = length(data.x);
			
			if (lengthAfter < lengthBefore)
				disp([num2str(lengthBefore) ' Datenpunkte vorher, ' num2str(lengthAfter) ' Datenpunkte nachher. Reduktion um ' num2str(100-100*lengthAfter/lengthBefore,3) ' %']);
			end;
			
			set(object, 'XData', data.x);
			set(object, 'YData', data.y);
		end;	
	end;
	
	disp(['Plot-Optimierung benötigte ' num2str(toc(optimizationDuration)) ' s.']);
end

% ===============================
function y = linFunction(x1,y1,x2,y2,x)
	m = (y2-y1)/(x2-x1);
	n = y1 - m*x1;
	y = m*x + n;
end