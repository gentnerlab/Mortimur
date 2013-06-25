function [query, anerror, errormsg, output] = DBadd_sort(conn, siteid, concatfilename, concatfilechan, sortmarkercode, sortquality, isolationtypeid, template_start, template_show, template_pre, template_n, primarySourceChan, n_chans, chan1_electrodepadid, chan1_threshold, chan2_electrodepadid, chan2_threshold, chan3_electrodepadid, chan3_threshold, chan4_electrodepadid, chan4_threshold, template_resolution, template_interval, template_scale, template_offset)

siteid = DBtool_num2strNULL(siteid);
concatfilename = DBtool_num2strNULL(concatfilename);
concatfilechan = DBtool_num2strNULL(concatfilechan);
sortmarkercode = ['''' DBtool_num2strNULL(sortmarkercode) '''']; %sortmarkercode needs explicit quotes because matlab has code as int, but DB wants a char
sortquality = DBtool_num2strNULL(sortquality,'double4places');
isolationtypeid = DBtool_num2strNULL(isolationtypeid);
template_start = DBtool_num2strNULL(template_start);
template_show = DBtool_num2strNULL(template_show);
template_pre = DBtool_num2strNULL(template_pre);
template_n = DBtool_num2strNULL(template_n);
primarySourceChan = DBtool_num2strNULL(primarySourceChan);
n_chans = DBtool_num2strNULL(n_chans);
chan1_electrodepadid = DBtool_num2strNULL(chan1_electrodepadid);
chan1_threshold = DBtool_num2strNULL(chan1_threshold,'double4places');
chan2_electrodepadid = DBtool_num2strNULL(chan2_electrodepadid);
chan2_threshold = DBtool_num2strNULL(chan2_threshold,'double4places');
chan3_electrodepadid = DBtool_num2strNULL(chan3_electrodepadid);
chan3_threshold = DBtool_num2strNULL(chan3_threshold,'double4places');
chan4_electrodepadid = DBtool_num2strNULL(chan4_electrodepadid);
chan4_threshold = DBtool_num2strNULL(chan4_threshold,'double4places');
template_resolution = DBtool_num2strNULL(template_resolution);
template_interval = DBtool_num2strNULL(template_interval);
template_scale = DBtool_num2strNULL(template_scale);
template_offset = DBtool_num2strNULL(template_offset);


query = ['select add_sort(' siteid ',' concatfilename ','  concatfilechan ',' sortmarkercode ',' sortquality ',' ...
    isolationtypeid ',' template_start ',' template_show ',' template_pre  ',' template_n ',' ...
    primarySourceChan ','  n_chans ',' chan1_electrodepadid  ',' chan1_threshold ',' chan2_electrodepadid ',' chan2_threshold ',' ...
    chan3_electrodepadid ',' chan3_threshold ',' chan4_electrodepadid ',' chan4_threshold ',' template_resolution ',' ...
    template_interval ',' template_scale ',' template_offset ')']; 
 

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    anerror = 0;
    errormsg = '';
    close(curs);
    output = data.Data{1};
else
    anerror = 1;
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    output = [];
end

end