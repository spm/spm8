function [] = spm_bms_display(BMS,action)
% display results from BMS Maps
% FORMAT spm_bms_display(BMS,action)
%
% Input:
% BMS    - BMS containing details of excurtion set
% action - 'Init' (Initialise), 'do_plot' (plot voxel results), 'save' (save
%          results as .img, 'overlays' (options overlays menu)
%_______________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Maria Joao Rosa
% $Id: spm_bms_display.m 2765 2009-02-19 15:30:54Z guillaume $

% Main options (action)
% =========================================================================
switch action
    
    % Inititalise - action: 'Init'
    % =====================================================================
    case 'Init'

    % Initialise variables
    % ---------------------------------------------------------------------
    xSPM  = BMS.xSPM; 
    M     = xSPM.xVol.M;
    iM    = xSPM.iM;
    DIM   = xSPM.xVol.DIM;
    units = {'mm' 'mm' 'mm'};
    title = 'Bayesian Model Selection';
    str   = xSPM.str;

    % Initialise figures
    % ---------------------------------------------------------------------
    [Finter,Fgraph,CmdLine] = spm('FnUIsetup','BMS: Results');
    FS = spm('FontSizes');
    WS = spm('WinScale');
    PF = spm_platform('fonts');

    % Clear satellite figure if it exists
    % ---------------------------------------------------------------------
    hSat = findobj('tag','Satellite');
    spm_figure('clear',hSat);

    % Setup Finter (interactive window)
    % ---------------------------------------------------------------------
    spm_figure('Clear',Finter);
    spm('FigName','BMS results',Finter,CmdLine);
    Finter  = spm_figure('GetWin',Finter);

    hReg    = uicontrol(Finter,'Style','Frame','Position',...
        [001 001 400 190].*WS,'BackgroundColor',spm('Colour'));
                       
    hFResUi = uicontrol(Finter,'Style','Frame','Position',...
        [008 007 387 178].*WS);
                       
    [hReg,xyz] = spm_XYZreg('InitReg',hReg,M,DIM,[0;0;0]);

    % Draw MIP
    % ---------------------------------------------------------------------
    hMIPax = axes('Parent',Fgraph,'Position',...
        [0.125 0.5450 0.59 0.40],'Visible','off');
    hMIPax = spm_mip_ui(xSPM.Z,xSPM.XYZmm,M,DIM,hMIPax,units);
    spm_XYZreg('XReg',hReg,hMIPax,'spm_mip_ui');
    hTitAx = axes('Parent',Fgraph,'Position',[0.02 0.95 0.86 0.02],...
        'Visible','off');
    text(0.5,0,title,'Parent',hTitAx,'HorizontalAlignment','center',...
        'VerticalAlignment','baseline','FontWeight','Bold','FontSize',FS(14))

    text(240,260,str,'Interpreter','TeX','FontSize',FS(14),...
        'Fontweight','Bold','Parent',hMIPax)
    
    % Print BMSresults: Results directory & thresholding info
    %----------------------------------------------------------------------
    hResAx = axes('Parent',Fgraph,...
        'Position',[0.160 0.510 0.45 0.05],...
        'DefaultTextVerticalAlignment','baseline',...
        'DefaultTextFontSize',FS(9),...
        'DefaultTextColor',[1,1,1]*.7,...
        'Units','points',...
        'Visible','off');
    AxPos = get(hResAx,'Position'); set(hResAx,'YLim',[0,AxPos(4)])
    h     = text(0,24,'BMSresults:','Parent',hResAx,...
        'FontWeight','Bold','FontSize',FS(14));
    text(get(h,'Extent')*[0;0;1;0],24,spm_str_manip(pwd,'a30'),'Parent',hResAx)
    text(0,12,sprintf('Threshold: %0.2d',BMS.xSPM.thres),'Parent',hResAx)
    
    % Store handles of results section Graphics window objects
    %----------------------------------------------------------------------
    H  = get(Fgraph,'Children');
    H  = findobj(H,'flat','HandleVisibility','on');
    H  = findobj(H);
    Hv = get(H,'Visible');
    set(hResAx,'Tag','PermRes','UserData',struct('H',H,'Hv',{Hv}))
    
    % Draw buttons
    %----------------------------------------------------------------------
    Finter = spm_figure('FindWin','Interactive');
    xyz    = [0;0;0];
    xyz    = spm_XYZreg('RoundCoords',xyz,M,DIM);

    % Create XYZ control objects
    % ---------------------------------------------------------------------
    hFxyz = uicontrol(Finter,'Style','Text',...
            'Position',[010 010 265 030].*WS);
    uicontrol(Finter,'Style','Text','String','co-ordinates',...
            'Position',[020 033 078 016].*WS,...
            'FontAngle','Italic',...
            'FontSize',FS(10),...
            'HorizontalAlignment','Left',...
            'ForegroundColor','w')

    uicontrol(Finter,'Style','Text','String','x =',...
            'Position',[020 015 024 018].*WS,...
            'FontName',PF.times,'FontSize',FS(10),'FontAngle','Italic',...
            'HorizontalAlignment','Center');
    hX   = uicontrol(Finter,'Style','Edit','String',...
            sprintf('%.2f',xyz(1)),...
            'ToolTipString','enter x-coordinate',...
            'Position',[044 015 056 020].*WS,...
            'FontSize',FS(10),'BackGroundColor',[.8,.8,1],...
            'HorizontalAlignment','Right',...
            'Tag','hX',...
            'Callback','spm_bms_display('''',''plot_xyz'')');

    uicontrol(Finter,'Style','Text','String','y =',...
            'Position',[105 015 024 018].*WS,...
            'FontName',PF.times,'FontSize',FS(10),'FontAngle','Italic',...
            'HorizontalAlignment','Center')
    hY   = uicontrol(Finter,'Style','Edit','String',...
            sprintf('%.2f',xyz(2)),...
            'ToolTipString','enter y-coordinate',...
            'Position',[129 015 056 020].*WS,...
            'FontSize',FS(10),'BackGroundColor',[.8,.8,1],...
            'HorizontalAlignment','Right',...
            'Tag','hY',...
            'Callback','spm_bms_display('''',''plot_xyz'')');

    uicontrol(Finter,'Style','Text','String','z =',...
            'Position',[190 015 024 018].*WS,...
            'FontName',PF.times,'FontSize',FS(10),'FontAngle','Italic',...
            'HorizontalAlignment','Center')
    hZ   = uicontrol(Finter,'Style','Edit','String',...
            sprintf('%.2f',xyz(3)),...
            'ToolTipString','enter z-coordinate',...
            'Position',[214 015 056 020].*WS,...
            'FontSize',FS(10),'BackGroundColor',[.8,.8,1],...
            'HorizontalAlignment','Right',...
            'Tag','hZ',...
            'Callback','spm_bms_display('''',''plot_xyz'')');
        
    % Voxel value reporting pane
    % ---------------------------------------------------------------------
    hFconB = uicontrol(Finter,'Style','Text',...
            'Position',[280 010 110 030].*WS);
    uicontrol(Finter,'Style','Text','String','voxel value',...
            'Position',[285 035 085 016].*WS,...
            'FontAngle','Italic',...
            'FontSize',FS(10),...
            'HorizontalAlignment','Left',...
            'ForegroundColor','w')
    hSPM = uicontrol(Finter,'Style','Text','String','',...
            'Position',[285 012 100 020].*WS,...
            'FontSize',FS(10),...
            'HorizontalAlignment','Center');
       
    % Store UserData
    % ---------------------------------------------------------------------
    set(hFxyz,'Tag','hFxyz','UserData',struct(...
              'hReg',   [],...
              'M',      M,...
              'iM',     iM,...
              'DIM',    DIM,...
              'XYZ',    xSPM.XYZmm,...
              'Z',      xSPM.Z,...
              'hX',     hX,...
              'hY',     hY,...
              'hZ',     hZ,...
              'hSPM',   hSPM,...
              'xSPM',   xSPM,...
              'fhFxyz', hFxyz,...
              'hMIPax', hMIPax,...
              'xyz',    xyz,...
              'thres',  BMS.xSPM.thres,...
              'scale',  BMS.xSPM.scale,...
              'vols',   BMS.xSPM.vols,...
              'BMS',    BMS));

    set([hX,hY,hZ],'UserData',hFxyz);
    
    % Register with hReg
    % ---------------------------------------------------------------------
    spm_XYZreg('XReg',hReg,hFxyz,'spm_results_ui');
    
    % Model partition
    % ---------------------------------------------------------------------
    uicontrol(Finter,'Style','PushButton','String','compare subsets',...
                'FontSize',FS(10),...
                'ToolTipString','Create and compare subsets of models',...
                'Callback','spm_bms_display('''',''partition'');',...
                'Interruptible','on','Enable','on',...
                'Position',[130 055 140 020].*WS,...
                'ForegroundColor','k');
           
    
    % Draw Save, Clear and Exit
    % ---------------------------------------------------------------------
    hClear = uicontrol(Finter,'Style','PushButton','String','clear',...
            'ToolTipString','clears results subpane',...
            'FontSize',FS(9),'ForegroundColor','b',...
            'Callback',['spm_results_ui(''Clear''); ',...
            'spm_input(''!DeleteInputObj''),',...
            'spm_clf(''Satellite'')'],...
            'Interruptible','on','Enable','on',...
            'DeleteFcn','spm_clf(''Graphics'')',...
            'Position',[285 055 035 020].*WS);

    hExit  = uicontrol(Finter,'Style','PushButton','String','exit',...
            'ToolTipString','exit the results section',...
            'FontSize',FS(9),'ForegroundColor','r',...
            'Callback',['spm_clf(''Interactive''),spm_clf(''Graphics''),'...
            'close(spm_figure(''FindWin'',''Satellite'')),'...
            'clear'],...
            'Interruptible','on','Enable','on',...
            'Position',[325 055 035 020].*WS);

    hHelp  = uicontrol(Finter,'Style','PushButton','String','?',...
            'ToolTipString','results section help',...
            'FontSize',FS(9),'ForegroundColor','g',...
            'Callback','spm_help(''spm_results_ui'')',...
            'Interruptible','on','Enable','on',...
            'Position',[365 055 020 020].*WS);
        
    % Change options
    % ---------------------------------------------------------------------
    uicontrol(Finter,'Style','Text',...
            'Position',[125 090 150 085].*WS)
    uicontrol(Finter,'Style','Text','String','options',...
            'Position',[135 168 60 015].*WS,...
            'FontAngle','Italic',...
            'FontSize',FS(10),...
            'HorizontalAlignment','Left',...
            'ForegroundColor','w')
    uicontrol(Finter,'Style','PushButton','String','results',...
            'Position',[130 145 140 020].*WS,...
            'ToolTipString',...
            'BMS Maps (Results)',...
            'Callback','spm_run_bms_vis',...
            'Interruptible','on','Enable','on',...
            'FontSize',FS(10),'ForegroundColor','k')
    uicontrol(Finter,'Style','PushButton','String','change model',...
            'Position',[130 120 140 020].*WS,...
            'ToolTipString',...
            'Change model/data',...
            'Callback','spm_bms_display('''',''change_data'')',...
            'Interruptible','on','Enable','on',...
            'FontSize',FS(10),'ForegroundColor','k')
    uicontrol(Finter,'Style','PushButton','String','threshold',...
            'Position',[130 95 68 020].*WS,...
            'ToolTipString',...
            'Change threshold (same data)',...
            'Callback','spm_bms_display('''',''change_thres'')',...
            'Interruptible','on','Enable','on',...
            'FontSize',FS(8),'ForegroundColor','k')
    uicontrol(Finter,'Style','PushButton','String','scale',...
            'Position',[202 95 68 020].*WS,...
            'ToolTipString',...
            'Change scale (same data)',...
            'Callback','spm_bms_display('''',''change_scale'')',...
            'Interruptible','on','Enable','on',...
            'FontSize',FS(8),'ForegroundColor','k')
    
    %-p-values
    %------------------------------------------------------------------
    uicontrol(Finter,'Style','Text','String','p-values',...
            'Position',[020 168 050 015].*WS,...
            'FontAngle','Italic',...
            'FontSize',FS(10),...
            'HorizontalAlignment','Left',...
            'ForegroundColor','w')
    uicontrol(Finter,'Style','PushButton','String','whole brain','FontSize',FS(10),...
            'ToolTipString',...
            'tabulate summary of local maxima, p-values & statistics',...
            'Callback','spm_bms_display('''',''list'');',...
            'Interruptible','on','Enable','on',...
            'Position',[015 145 100 020].*WS)
    uicontrol(Finter,'Style','PushButton','String','current cluster','FontSize',FS(10),...
            'ToolTipString',...
            'tabulate p-values & statistics for local maxima of nearest cluster',...
            'Callback','spm_bms_display('''',''listCluster'');',...
            'Interruptible','on','Enable','on',...
            'Position',[015 120 100 020].*WS)
    uicontrol(Finter,'Style','PushButton','String','','FontSize',FS(10),...
            'Enable','on',...
            'Callback','',...
            'Position',[015 095 100 020].*WS)
        
    % Draw Options
    % ---------------------------------------------------------------------
uicontrol(Finter,'Style','Text',...
            'Position',[280 090 110 085].*WS)
    uicontrol(Finter,'Style','Text','String','display',...
            'Position',[290 168 065 015].*WS,...
            'FontAngle','Italic',...
            'FontSize',FS(10),...
            'HorizontalAlignment','Left',...
            'ForegroundColor','w')
    uicontrol(Finter,'Style','PushButton','String','plot','FontSize',...
            FS(10),'ToolTipString','plot results at current voxel',...
            'Callback','spm_bms_display('''',''do_plot'')',...
            'Interruptible','on','Enable','on',...
            'Position',[285 145 100 020].*WS,...
            'Tag','plotButton')
    str  = { 'overlays...','slices','sections','render','previous sections'};
    tstr = { 'overlay results on another image: ',...
        '3 slices / ''ortho sections / ','render /','previous ortho sections'};
    tmp  = { 'spm_transverse(''set'',xSPM,hReg)',...
            'spm_sections(xSPM,hReg)',...
            ['spm_render(   struct( ''XYZ'',    xSPM.XYZ,',...
            '''t'',     xSPM.Z'',',...
            '''mat'',   xSPM.M,',...
            '''dim'',   xSPM.DIM))'],...
            ['global prevsect;','spm_sections(xSPM,hReg,prevsect)'],...
            ['global prevrend;','if ~isstruct(prevrend)',...
            'prevrend = struct(''rendfile'','''',''brt'',[],''col'',[]); end;',...            
            'spm_render(    struct( ''XYZ'',    xSPM.XYZ,',...
            '''t'',     xSPM.Z'',',...
            '''mat'',   xSPM.M,',...
            '''dim'',   xSPM.DIM),prevrend.brt,prevrend.rendfile)']};
    uicontrol(Finter,'Style','PopUp','String',str,'FontSize',FS(10),...
            'ToolTipString',cat(2,tstr{:}),...
            'Callback','spm_bms_display('''',''overlays'')',...
            'UserData',tmp,...
            'Interruptible','on','Enable','on',...
            'Position',[285 120 100 020].*WS)
    uicontrol(Finter,'Style','PushButton','String','save','FontSize',...
            FS(10),'ToolTipString','save thresholded BMS as image',...
            'Callback','spm_bms_display('''',''save'')',...
            'Interruptible','on','Enable','on',...
            'Position',[285 095 100 020].*WS)
    user_data = get(hFxyz,'UserData');
    set(Finter,'UserData',user_data,...
            'HandleVisibility','callback')

    % Do plot - action: 'do_plot'
    % =====================================================================
    case 'do_plot'
        
        fig       = gcf;
        user_data = get(fig,'UserData');
        iM        = user_data.iM;
        BMS       = user_data.BMS;
        user_data = get(user_data.hMIPax,'UserData');
        user_data = get(user_data.hMIPxyz,'UserData');
        xyz_vx    = iM*[user_data; 1];
        spm_bms_display_vox(BMS,xyz_vx(1:3));     

    % Do overlays - action: 'overlays'
    % =====================================================================
    case 'overlays'
        
        h   = gcbo;
        v   = get(h,'Value');
        if v==1, return, end
        set(h,'Value',1)
        CBs       = get(h,'UserData');
        fig       = gcf;
        user_data = get(fig,'UserData');
        hReg      = user_data.hReg;
        xSPM      = user_data.xSPM;
        eval(CBs{v-1})
      
    % Save - action: 'save'
    % =====================================================================
    case 'save'  
        
        fig       = gcf;
        user_data = get(fig,'UserData');
        xSPM      = user_data.xSPM;
        spm_write_filtered(xSPM.Z,xSPM.XYZ,xSPM.DIM,xSPM.M,'Results saved');
     
    % Plot xyz BMS values - action: 'plot_xyz'
    % =====================================================================
    case 'plot_xyz'
        
        hC    = gcbo;
        d     = find(strcmp(get(hC,'Tag'),{'hX','hY','hZ'}));
        hFxyz = get(hC,'UserData');
        UD    = get(hFxyz,'UserData');
        xyz   = UD.xyz;
        nxyz  = xyz;

        o = evalin('base',['[',get(hC,'String'),']'],'sprintf(''error'')');
        if ischar(o) || length(o)>1
            warning('%s: Error evaluating ordinate:\n\t%s',...
                mfilename,lasterr)
        else
            nxyz(d) = o;
            nxyz = spm_XYZreg('RoundCoords',nxyz,UD.M,UD.DIM);
        end

        if abs(xyz(d)-nxyz(d))>0
            UD.xyz = nxyz; set(hFxyz,'UserData',UD)
            if ~isempty(UD.hReg), spm_XYZreg('SetCoords',nxyz,UD.hReg,hFxyz); end
            set(hC,'String',sprintf('%.3f',nxyz(d)))
            i  = spm_XYZreg('FindXYZ',UD.xyz,UD.XYZ);
            if isempty(i), str = ''; else str = sprintf('%6.2f',UD.Z(i)); end
               set(UD.hSPM,'String',str);
        end
        
        fig = gcf;
        set(fig,'UserData',UD)
     
    % Change model
    % =====================================================================    
    case 'change_data'
        
        fig         = gcf;
        user_data   = get(fig,'UserData');
        job.img{1}  = '';
        job.file{1} = user_data.BMS.fname;
        job.thres   = user_data.thres;
        job.scale   = user_data.scale;
        spm_run_bms_vis(job);
    
    % Change threshold
    % =====================================================================
    case 'change_thres'
        
        fig         = gcf;
        user_data   = get(fig,'UserData');
        job.img{1}  = user_data.vols;
        job.thres   = [];
        job.file{1} = user_data.BMS.fname;
        job.scale   = user_data.scale;
        spm_run_bms_vis(job);
    
    % Change scale
    % =====================================================================
    case 'change_scale'
        
        fig         = gcf;
        user_data   = get(fig,'UserData');
        job.img{1}  = user_data.vols;
        job.thres   = user_data.thres;
        job.scale   = [];
        job.file{1} = user_data.BMS.fname;
        spm_run_bms_vis(job);
    
    % List p-values
    % =====================================================================
    case 'list'
        
        fig       = gcf;
        user_data = get(fig,'UserData');
        xSPM      = user_data.xSPM;
        hReg      = user_data.hReg;
        xSPM.STAT = 'P';
        xSPM.Z    = xSPM.z_ps;
        spm_list('List',xSPM,hReg);
   
    % List cluster
    % =====================================================================
    case 'listCluster'
        
        fig       = gcf;
        user_data = get(fig,'UserData');
        xSPM      = user_data.xSPM;
        hReg      = user_data.hReg;
        xSPM.STAT = 'P';
        xSPM.Z    = xSPM.z_ps;
        spm_list('ListCluster',xSPM,hReg);
        
    % Small volume
    % =====================================================================
    case 'VOI'
        
        fig       = gcf;
        user_data = get(fig,'UserData');
        xSPM      = user_data.xSPM;
        hReg      = user_data.hReg;
        xSPM.STAT = 'P';
        spm_VOI(BMS,xSPM,hReg);
        
    % Model partitioning
    % =====================================================================
    case 'partition'    
        fig       = gcf;
        user_data = get(fig,'UserData');
        BMS       = user_data.BMS;
        spm_bms_partition(BMS);
        
end  % End switch  

end  % End function


        