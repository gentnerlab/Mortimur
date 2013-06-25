function DBplot_psthcell_bystim(conn,cellid)
%%
[sn stimids] = DBget_stim_cell(conn,cellid);
[trialids] = DBget_trial_cell(conn,cellid);

st = [];
figure
for i = 1:length(stimids)
    ax = subplot(length(stimids),1,i);
    currtrialids = DBget_trial(conn, ['trialid IN ' DBtool_inlist(trialids) ' AND stimulusid = ' DBtool_num2strNULL(stimids(i))]);
    spiketrainids = DBget_spiketrainids(conn,cellid,currtrialids);
    DBplot_psth_spiketrains(conn,spiketrainids,'ax',ax,'binsize',50,'smoothmethod','gauss');
end

end