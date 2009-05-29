function cat = spm_cfg_cat
% SPM Configuration file
% automatically generated by the MATLABBATCH utility function GENCODE
%_______________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% $Id: spm_cfg_cat.m 1294 2008-04-02 14:26:56Z volkmar $

rev = '$Rev: 1294 $';
% ---------------------------------------------------------------------
% vols 3D Volumes
% ---------------------------------------------------------------------
vols         = cfg_files;
vols.tag     = 'vols';
vols.name    = '3D Volumes';
vols.help    = {'Select the volumes to concatenate'};
vols.filter = 'image';
vols.ufilter = '.*';
vols.num     = [1 Inf];
% ---------------------------------------------------------------------
% cat 3D to 4D
% ---------------------------------------------------------------------
cat         = cfg_exbranch;
cat.tag     = 'cat';
cat.name    = '3D to 4D';
cat.val     = {vols };
cat.help    = {
               'Concatenate a number of 3D volumes into a single 4D file.'
               'Note that output time series are stored as big-endian int16.'
}';
cat.prog = @spm_run_cat;