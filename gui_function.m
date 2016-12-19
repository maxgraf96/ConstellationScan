function sample_gui(input)
%Create then hide the UI as it is being constructed
height = 500;
width = 1000;

f = figure('Visible','off',...
           'Position',[100,100,width,height]);

btnStart = uicontrol('Style','pushbutton',...
                     'String','Start',...
                     'Position',[(width/2)-(width/40)-(width/10),height/10,width/10,height/20],...
                     'Callback',@startbutton_Callback);
btnCount = uicontrol('Style','pushbutton',...
                     'String','Count',...
                     'Position',[(width/2)+(width/40),height/10,width/10,height/20],...
                     'Callback',@countbutton_Callback);
sldThreshold = uicontrol('Style','slider',...
                         'Position',[width/40,height/5,(width/20)*9,height/20],...
                         'Callback',@thresholdslider_Callback,...
                         'Value',0.0,...
                         'Max',1.0,...
                         'Min',0.0);
sldAngle = uicontrol('Style','slider',...
                     'Position',[(width/40)*21,height/5,(width/20)*9,height/20],...
                     'Callback',@angleslider_Callback,...
                     'Value', 1.0,...
                     'Max',5.0,...
                     'Min',1.0);
textThreshold = uicontrol('Style','text',...
                          'String','Threshold: 0.0',...
                          'Position',[width/40,((height/5) + (height/20)*6)/2,(width/20)*9,height/20],...
                          'FontSize',round((sqrt(width * height)/80)));
textAngle = uicontrol('Style','text',...
                      'String','Angle Tolerance: 1.0',...
                      'Position',[(width/40)*21,((height/5) + (height/20)*6)/2,(width/20)*9,height/20],...
                      'FontSize',round((sqrt(width * height)/80)));
textCount = uicontrol('Style','text',...
                      'String','0 Stars found',...
                      'Position',[(width/10)*4,((height/5) + (height/20)*6)/2,(width/10)*2,height/20],...
                      'FontSize',round((sqrt(width * height)/80)));
axesThreshold = axes('Units','pixels',...
                     'Position',[width/40, (height/20)*6, (width/20)*9, (height/10)*7],...
                     'XTick',[],...
                     'YTick',[]);
axesSolution = axes('Units','pixels',...
                    'Position',[(width/40)*21, (height/20)*6, (width/20)*9, (height/10)*7],...
                    'XTick',[],...
                    'YTick',[]);

%Variables
threshold_value = 0;
angle_tolerance = 1;
input_label = im2bw(input, threshold_value);
input_closed = zeros(size(input_label));

%Change units to normalized so components resize automatically.
f.Units = 'normalized';
btnStart.Units = 'normalized';
btnCount.Units = 'normalized';
sldThreshold.Units = 'normalized';
sldAngle.Units = 'normalized';
textCount.Units = 'normalized';
textThreshold.Units = 'normalized';
textAngle.Units = 'normalized';
axesSolution.Units = 'normalized';
axesThreshold.Units = 'normalized';

%Move Window to center of the screen
movegui(f,'center');

%Set Name for GUI
f.Name = 'Constellation Scan Setup';

f.Visible = 'on';

%Initalize GUI Pictures
cla(axesSolution);
axes(axesSolution);
imshow(input);
cla(axesThreshold);
axes(axesThreshold);
imshow(input_label);

%Callbacks:
    function startbutton_Callback(source, eventdata)
        input_label = CCL(input_closed);
        solution = main(input_label, input, angle_tolerance);
        
        cla(axesSolution);
        axes(axesSolution);
        imshow(solution);
    end

    function countbutton_Callback(source, eventdata)
        input_label = CCL(input_closed);
        count_closed = max(input_label(:));
        
        set(textCount,'String',strcat(num2str(count_closed), ' Stars found'));
    end

    function thresholdslider_Callback(source, eventdata)
        threshold_value = source.Value;
        
        set(textThreshold,'String',strcat('Threshold: ',num2str(threshold_value)));
        
        input_bw = im2bw(input, threshold_value);
       
        se = strel('disk',round((sqrt(size(input_bw, 1) * size(input_bw, 2))/100)));
        input_closed = imdilate(input_bw,se);       
        
        cla(axesThreshold);
        axes(axesThreshold);
        imshow(input_closed);
    end

    function angleslider_Callback(source, eventdata)
        angle_tolerance = source.Value;
        
        set(textAngle,'String',strcat('Angle Tolerance: ',num2str(angle_tolerance)));
    end
end