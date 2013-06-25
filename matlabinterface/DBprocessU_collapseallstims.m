function DBprocessU_collapseallstims(conn)

%help from the file that does most of the work:
%[trialids, sstrialids] = DBprocessU_collapsestimulusaliases(conn,keepstimulusid,redundantstimulusids)
% the same stimuli have been used with different names across ndege, and multiple instances of recording on chron rig
%this function will allow the user to manually reassign the stimulusids in the trial, sstrial, and stimcalc tables of
%the redundant names to the accepted canonical database name
%the redundant rows will NOT be removed from the stimulus table, rather
%references to their stimulusid will be modified in the trial, sstrial, and
%stimcalc tables

X = SM_SS_readsetstimfile(fixfilesep([getdanroot '\stimuli\singlemotiflibrary_40000Hz\renamed\BLANKsetstims.stim']));
X = X(:,1);

keepRedundant1Redundant2names(:,1) = X;
keepRedundant1Redundant2names(:,2) = X;

keepRedundant1Redundant2names(:,1) = strrep(keepRedundant1Redundant2names(:,1),'.wav','');

for currstim = 1:size(keepRedundant1Redundant2names,1)
    keepRedundant1Redundant2names{currstim,3}  = makeoldname(keepRedundant1Redundant2names{currstim,1});
    keepRedundant1Redundant2names{currstim,4} = [keepRedundant1Redundant2names{currstim,3} '.wav'];
end

keepRedundant1Redundant2ids = cell(1,2);
for currfix = 1:size(keepRedundant1Redundant2names,1)
    currfix
    keepstimulusid = cell2mat(DBx(conn,['SELECT DISTINCT stimulusid from stimulus where stimulusfilename = ' DBtool_num2strNULL(keepRedundant1Redundant2names{currfix,1})]));
    if numel(keepstimulusid) == 0
        %DBadd_stimulus(conn, keepRedundant1Redundant2{currfix,1}, 'null', 'null');
    end
    keepstimulusid = cell2mat(DBx(conn,['SELECT DISTINCT stimulusid from stimulus where stimulusfilename = ' DBtool_num2strNULL(keepRedundant1Redundant2names{currfix,1})]));
    if numel(keepstimulusid) ~= 1
        error();
    end
    
    redundantstimulusids = cell2mat(DBx(conn,['SELECT DISTINCT stimulusid from stimulus where stimulusfilename in ' DBtool_inlist(keepRedundant1Redundant2names(currfix,2:4))]));
    matches(currfix) = numel(redundantstimulusids);
    
    
    keepRedundant1Redundant2ids{currfix,1}=keepstimulusid;
    keepRedundant1Redundant2ids{currfix,2}=redundantstimulusids;
    if numel(redundantstimulusids) > 0
        %DBprocessU_collapsestimulusaliases(conn,keepstimulusid,redundantstimulusids)
    end
end
zz=1;
end

function oldname = makeoldname(newname)

bird = newname(2:4);

song = newname(6:8);
song = str2double(song);

class = newname(10:12);
if class(1) == '0'
    class = class(2:end);
end
if class(1) == '0'
    class = class(2:end);
end
if class(1) == '0'
    error('erm?!?');
end

position = newname(14:16);
position = str2double(position);

if ismember(bird,{'AAA','BBB','CCC','DDD','EEE','FFF','GGG'});
    bird = bird(1);
    oldname = sprintf('%s_%s%d_@%d',class,bird,song,position);
else
    oldname = sprintf('%s_%s_s%02d_@%d',class,bird,song,position);
end


end