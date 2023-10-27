classdef TM5 < RobotBaseClass
    %% TM5-700 Omron cobot


    properties(Access = public)   
        plyFileNameStem = 'TM5';
    end
    
    methods
%% Constructor
        function self = TM5(baseTr,useTool,toolFilename)
   
            if nargin < 3
                if nargin == 2
                    error('If you set useTool you must pass in the toolFilename as well');
                elseif nargin == 0 
                    baseTr = transl(0,0,0);  
                end             
            else % All passed in 
                self.useTool = useTool;
                toolTrData = load([toolFilename,'.mat']);
                self.toolTr = toolTrData.tool;
                self.toolFilename = [toolFilename,'.ply'];
                rotate(toolFilename, 90)
            end
            self.CreateModel();
			self.model.base = self.model.base.T * baseTr;
            self.model.tool = self.toolTr;
            self.PlotAndColourRobot();
            
            drawnow
        end
%% CreateModel
        function CreateModel(self)
            link(1) = Link('d',0.1451 ,'a',0 ,'alpha',-pi/2 ,'qlim',deg2rad([-277 277]), 'offset',0);
            link(2) = Link('d',0 ,'a',0.329,'alpha',0,'qlim', deg2rad([-100 100]), 'offset',-pi/2);
            link(3) = Link('d',0,'a',0.3115,'alpha',0,'qlim', deg2rad([-100 100]), 'offset', 0);
            link(4) = Link('d',-0.1222,'a',0,'alpha',pi/2,'qlim',deg2rad([-100 100]),'offset', pi/2);
            link(5) = Link('d',0.106,'a',0,'alpha',pi/2 ,'qlim',deg2rad([-100 100]), 'offset',0);
            link(6) = Link('d',0.1144,'a',0,'alpha',0 ,'qlim',deg2rad([-277,277]), 'offset', 0);

             
            self.model = SerialLink(link,'name',self.name);
        end   
    end
end
