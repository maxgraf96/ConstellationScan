function sample_gui(input)
%Create then hide the UI as it is being constructed
f = figure('Visible','off',...
           'Position',[100,100,800,500]);

btnStart = uicontrol('Style','pushbutton',...
                     'String','Start',...
                     'Position',[365,50,70,25],...
                     'Callback',@startbutton_Callback);                
sldThreshold = uicontrol('Style','slider',...
                         'Position',[100,100,250,25],...
                         'Callback',@thresholdslider_Callback,...
                         'Max',1.0,...
                         'Min',0.0);
sldAngle = uicontrol('Style','slider',...
                     'Position',[450,100,250,25],...
                     'Callback',@angleslider_Callback,...
                     'Max',5.0,...
                     'Min',0.0);
textThreshold = uicontrol('Style','text',...
                          'String','Threshold: 0.0',...
                          'Position',[150,135,150,15]);
textAngle = uicontrol('Style','text',...
                      'String','Angle Tolerance: 0.0',...
                      'Position',[500,135,150,15]);
axesThreshold = axes('Units','pixels',...
                     'Position',[30, 200, 350, 250],...
                     'XTick',[],...
                     'YTick',[]);
axesSolution = axes('Units','pixels',...
                    'Position',[420, 200, 350, 250],...
                    'XTick',[],...
                    'YTick',[]);

%Variables
threshold_value = 0;
angle_tolerance = 0;
input_bw = im2bw(input, threshold_value);

%Change units to normalized so components resize automatically.
f.Units = 'normalized';
btnStart.Units = 'normalized';
sldThreshold.Units = 'normalized';
sldAngle.Units = 'normalized';
axesSolution.Units = 'normalized';
axesThreshold.Units = 'normalized';

%Move Window to center of the screen
movegui(f,'center');

%Set Name for GUI
f.Name = 'Constellation Scan Setup';

f.Visible = 'on';

%Callbacks:
    function startbutton_Callback(source, eventdata)
        solution = main(input_bw,angle_tolerance);
        
        axes(axesSolution);
        imshow(solution);
    end

    function thresholdslider_Callback(source, eventdata)
        threshold_value = source.Value;
        
        set(textThreshold,'String',strcat('Threshold: ',num2str(threshold_value)));
        
        input_bw = im2bw(input, threshold_value);
        
        axes(axesThreshold);
        imshow(input_bw);
    end

    function angleslider_Callback(source, eventdata)
        angle_tolerance = source.Value;
        
        set(textAngle,'String',strcat('Angle Tolerance: ',num2str(angle_tolerance)));
    end
end