function DBdobatch(conn,sqlStrings)

%from: http://www.mathworks.com/support/solutions/en/data/1-21BOPN/index.html?product=DB&solution=1-21BOPN
% sqlStrings contains several SQL INSERT statements of the form
% INSERT INTO BONUS (ENAME,JOB,SAL,COMM) VALUES ('Nomar', 'Shortstop', 1000000, 50)

connHandle = conn.Handle;
stmt = connHandle.createStatement;

for i = 1:numel(sqlStrings)
    stmt.addBatch(sqlStrings{i});
end

stmt.executeBatch;
stmt.close;

end