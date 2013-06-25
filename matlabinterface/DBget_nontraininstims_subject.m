function nontrainingstims = DBget_nontraininstims_subject(conn,subjectid)


allstims = DBget_stim_subject(conn,subjectid);
trainingstims = DBget_trainingstims_subject(conn,subjectid);

nontrainingstims = setdiff(allstims,trainingstims);

