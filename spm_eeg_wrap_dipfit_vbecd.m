function [y,outside]=spm_eeg_wrap_dipfit_vbecd(P,M,U)
% A cost function/wrapper to sit between non-linear optimisation spm_nlsi_gn.m
% and dipole fit routine spm__eeg_inv_vbecd.m
% sens and vol structures should be passed in M, where
%   sens=M.Setup.forward.sens;
%   vol=M.Setup.forward.vol;
% P contains a list of the free parameters (assuming all position
%   parameters come first (in triplets) followed by all moment paameters
%   (also in triplets)
% U is unused 
% At the moment this removes the mean level from EEG data
% and reduces the rank of the MEG leadfield 2 dimensions. 

% Copyright (C) 2009 Wellcome Trust Centre for Neuroimaging
% 
% $Id: spm_eeg_wrap_dipfit_vbecd.m 3372 2009-09-08 14:33:45Z gareth $

x=U.u; %% input , unused


sens=M.Setup.forward.sens;
vol=M.Setup.forward.vol;
posandmom=P;

Pospars=3;
Mompars=3;
Ndippars=Pospars+Mompars;
Ndips=length(posandmom)/Ndippars;
if Ndips~=round(Ndips),
    error('only works for 6 params per dipole');
end; % if
allpos=reshape(P(1:Ndips*Pospars),Pospars,Ndips)';
allmom=reshape(P(Ndips*Pospars+1:Ndips*Ndippars),Mompars,Ndips)';

MEGRANK=2; %% restricting rank of MEG data, could change this in future

y=0;
outside=0;
for i=1:Ndips,
    
    pos=allpos(i,:);
    mom=allmom(i,:);
    
    % mean correction of LF, only for EEG data.
    if forwinv_senstype(sens, 'eeg')
       [tmp] = forwinv_compute_leadfield(pos, sens, vol);
        tmp = tmp - repmat(mean(tmp), size(tmp,1), 1); %% should this be here ?
    else %% reduce rank of leadfield for MEG- assume one direction (radial) is silent
       [tmp] = forwinv_compute_leadfield(pos, sens, vol,'reducerank',MEGRANK);
    end
    gmn=tmp;       
    y=y+gmn*mom';
    outside = outside+ ~forwinv_inside_vol(pos,vol);
end; % for i


y=y*M.sc_y; %% scale data appropriately
if outside
    y=y.^2;
    end;  % penalise sources outside head




